# Nix-Config Refactoring Guide

## Current Architecture Analysis

Based on analysis of the existing codebase, here are the key architectural components and issues that need addressing in a rewrite:

### Current Strengths
- Well-structured flake with clear separation of concerns
- Comprehensive hostSpec module system for host differentiation
- Good secrets management with sops-nix
- Custom package management through overlays
- Automated build and deploy scripts via justfile
- Multi-user and multi-host support

### Current Pain Points (from TODO.md)
1. **Module System**: Need to refactor modules to use more extensive specialArgs and extraSpecialArgs
2. **Options System**: Re-implement modules to make use of proper options for enablement
3. **Script Quality**: Consider nixifying bash scripts for better reliability
4. **Duplication**: Reduce duplication in configurations
5. **Impermanence**: Need to implement proper impermanence support

## Detailed Refactoring Plan

### Phase 1: Foundation & Build System

#### 1.1 Flake Architecture
**Current State**: Good foundation with 235-line flake.nix
**Improvements Needed**:
```nix
# Enhanced flake.nix structure
{
  inputs = {
    # Core inputs with better version pinning
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Enhanced home-manager integration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Add nixos-generators for ISO building
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib.extend (self: super: { 
        custom = import ./lib { inherit (nixpkgs) lib; }; 
      });
      
      # Enhanced system configurations with better specialArgs
      mkSystem = { hostname, platform ? "nixos", extraSpecialArgs ? {} }:
        let
          platformLib = if platform == "darwin" then nix-darwin.lib else nixpkgs.lib;
          systemBuilder = if platform == "darwin" then "darwinSystem" else "nixosSystem";
        in
        platformLib.${systemBuilder} {
          specialArgs = {
            inherit inputs outputs lib;
            isDarwin = platform == "darwin";
            hostSpec = {
              hostName = hostname;
              platform = platform;
            };
          } // extraSpecialArgs;
          modules = [ ./hosts/${platform}/${hostname} ];
        };
    in
    {
      # Dynamic host configuration generation
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = mkSystem { hostname = host; };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );
      
      # Enhanced packages with per-platform support
      packages = forAllSystems (system: 
        import ./pkgs { 
          inherit inputs system;
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );
    };
}
```

#### 1.2 Enhanced Library Functions
**Current State**: Basic lib with scanPaths and relativeToRoot
**Enhancements Needed**:
```nix
# lib/default.nix
{ lib, ... }: {
  # Existing functions
  relativeToRoot = lib.path.append ../.;
  scanPaths = path: /* existing implementation */;
  
  # New helper functions
  mkOption = {
    type ? lib.types.anything,
    default ? null,
    description ? "",
    example ? null,
    ...
  }: lib.mkOption {
    inherit type default description example;
  };
  
  # Better module system helpers
  mkModule = { config, options, ... }: {
    inherit config options;
  };
  
  # Host detection helpers
  isLinux = system: lib.hasPrefix "linux" system;
  isDarwin = system: lib.hasPrefix "darwin" system;
  
  # Enhanced configuration merging
  mkIf = condition: config: lib.mkIf condition config;
  mkDefault = lib.mkDefault;
  mkForce = lib.mkForce;
}
```

### Phase 2: Module System Refactoring

#### 2.1 Options-Based Module Architecture
**Current Issue**: Modules don't consistently use options for enablement
**Solution**: Convert all modules to use proper options system

```nix
# modules/nixos/gaming.nix - Example refactored module
{ config, lib, pkgs, ... }:
let
  cfg = config.mySystem.gaming;
in
{
  options.mySystem.gaming = {
    enable = lib.mkEnableOption "gaming support";
    
    steam = {
      enable = lib.mkEnableOption "Steam gaming platform";
      gamescope = lib.mkEnableOption "Gamescope compositor";
    };
    
    gamemode = lib.mkEnableOption "GameMode optimizations";
    
    hardware = {
      controllers = lib.mkEnableOption "gaming controllers support";
      rgb = lib.mkEnableOption "RGB lighting support";
    };
  };
  
  config = lib.mkIf cfg.enable {
    programs.steam = lib.mkIf cfg.steam.enable {
      enable = true;
      gamescopeSession.enable = cfg.steam.gamescope;
    };
    
    programs.gamemode.enable = cfg.gamemode;
    
    hardware.xpadneo.enable = cfg.hardware.controllers;
    services.hardware.openrgb.enable = cfg.hardware.rgb;
  };
}
```

#### 2.2 Enhanced HostSpec System
**Current State**: Good foundation but needs more specialArgs integration
**Improvements**:
```nix
# modules/common/host-spec.nix - Enhanced version
{ config, lib, ... }:
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      options = {
        # Core identification
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of the system";
        };
        
        platform = lib.mkOption {
          type = lib.types.enum [ "nixos" "darwin" ];
          description = "Platform type";
        };
        
        # Hardware specifications  
        hardware = lib.mkOption {
          type = lib.types.submodule {
            options = {
              cpu = lib.mkOption {
                type = lib.types.enum [ "intel" "amd" "apple" ];
                description = "CPU vendor";
              };
              gpu = lib.mkOption {
                type = lib.types.enum [ "nvidia" "amd" "intel" "apple" ];
                description = "GPU vendor";
              };
              hasWifi = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "System has WiFi capability";
              };
            };
          };
          default = {};
        };
        
        # Role-based configuration
        role = lib.mkOption {
          type = lib.types.enum [ "desktop" "laptop" "server" "minimal" ];
          description = "System role";
        };
        
        # Feature flags
        features = lib.mkOption {
          type = lib.types.submodule {
            options = {
              gaming = lib.mkEnableOption "gaming features";
              development = lib.mkEnableOption "development tools";
              media = lib.mkEnableOption "media production";
              server = lib.mkEnableOption "server services";
            };
          };
          default = {};
        };
        
        # Security configuration
        security = lib.mkOption {
          type = lib.types.submodule {
            options = {
              yubikey = lib.mkEnableOption "YubiKey support";
              tpm = lib.mkEnableOption "TPM support";
              secureBoot = lib.mkEnableOption "Secure Boot";
            };
          };
          default = {};
        };
      };
    };
  };
}
```

### Phase 3: Service and Application Modules

#### 3.1 Desktop Environment Modules
**Current Issue**: Hyprland/Sway configs need separation
**Solution**: Modular WM configuration

```nix
# modules/nixos/desktop/wayland.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.mySystem.desktop.wayland;
in
{
  options.mySystem.desktop.wayland = {
    enable = lib.mkEnableOption "Wayland desktop support";
    
    compositor = lib.mkOption {
      type = lib.types.enum [ "hyprland" "sway" "river" ];
      default = "hyprland";
      description = "Wayland compositor to use";
    };
    
    features = {
      screenSharing = lib.mkEnableOption "screen sharing support";
      notifications = lib.mkEnableOption "desktop notifications";
      launcher = lib.mkEnableOption "application launcher";
    };
  };
  
  config = lib.mkIf cfg.enable {
    # Common Wayland setup
    services.xserver.displayManager.gdm.wayland = true;
    
    # Compositor-specific configuration
    programs.hyprland.enable = cfg.compositor == "hyprland";
    programs.sway.enable = cfg.compositor == "sway";
    
    # Feature-based configuration
    xdg.portal = lib.mkIf cfg.features.screenSharing {
      enable = true;
      wlr.enable = true;
    };
    
    services.dunst.enable = cfg.features.notifications;
    programs.rofi.enable = cfg.features.launcher;
  };
}
```

#### 3.2 Development Environment Module
```nix
# modules/nixos/development.nix
{ config, lib, pkgs, ... }:
let
  cfg = config.mySystem.development;
in
{
  options.mySystem.development = {
    enable = lib.mkEnableOption "development environment";
    
    languages = {
      nix = lib.mkEnableOption "Nix development tools";
      rust = lib.mkEnableOption "Rust development";
      python = lib.mkEnableOption "Python development";
      node = lib.mkEnableOption "Node.js development";
    };
    
    tools = {
      vscode = lib.mkEnableOption "Visual Studio Code";
      git = lib.mkEnableOption "Git tools";
      containers = lib.mkEnableOption "Container tools";
    };
  };
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; lib.flatten [
      # Nix tools
      (lib.optional cfg.languages.nix [
        nil nixfmt-rfc-style deadnix
      ])
      
      # Rust tools  
      (lib.optional cfg.languages.rust [
        rustc cargo rustfmt clippy
      ])
      
      # Development tools
      (lib.optional cfg.tools.git [
        git git-lfs gh
      ])
      
      (lib.optional cfg.tools.containers [
        docker podman
      ])
    ];
    
    programs.vscode.enable = cfg.tools.vscode;
    virtualisation.docker.enable = cfg.tools.containers;
  };
}
```

### Phase 4: Secrets and Security

#### 4.1 Enhanced SOPS Configuration
**Current State**: Working but could be more modular
**Improvements**:
```nix
# modules/nixos/security/sops.nix
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.mySystem.security.sops;
  secretsDir = builtins.toString inputs.nix-secrets;
in
{
  options.mySystem.security.sops = {
    enable = lib.mkEnableOption "SOPS secrets management";
    
    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/ssh/ssh_host_ed25519_key";
      description = "Age key file for decryption";
    };
    
    secretsFile = lib.mkOption {
      type = lib.types.str;
      default = "${secretsDir}/secrets.yaml";
      description = "SOPS secrets file";
    };
    
    userSecrets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          owner = lib.mkOption {
            type = lib.types.str;
            description = "Owner of the secret";
          };
          group = lib.mkOption {
            type = lib.types.str;
            description = "Group of the secret";
          };
          mode = lib.mkOption {
            type = lib.types.str;
            default = "0400";
            description = "File permissions";
          };
        };
      });
      default = {};
      description = "User-specific secrets configuration";
    };
  };
  
  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.secretsFile;
      age.keyFile = cfg.ageKeyFile;
      
      secrets = lib.mapAttrs (name: secretCfg: {
        inherit (secretCfg) owner group mode;
      }) cfg.userSecrets;
    };
  };
}
```

### Phase 5: Impermanence Implementation

#### 5.1 Impermanence Module
**Current Issue**: Mentioned in TODO but not implemented
**Solution**:
```nix
# modules/nixos/system/impermanence.nix
{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.mySystem.impermanence;
in
{
  options.mySystem.impermanence = {
    enable = lib.mkEnableOption "root filesystem impermanence";
    
    persistPath = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Path to persistent storage";
    };
    
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
      description = "Directories to persist";
    };
    
    files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
      description = "Files to persist";
    };
    
    userDirs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      default = {};
      description = "Per-user directories to persist";
    };
  };
  
  config = lib.mkIf cfg.enable {
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    
    environment.persistence.${cfg.persistPath} = {
      hideMounts = true;
      directories = cfg.directories;
      files = cfg.files;
      
      users = lib.mapAttrs (user: dirs: {
        directories = dirs;
      }) cfg.userDirs;
    };
    
    # Ensure persist directory exists
    systemd.tmpfiles.rules = [
      "d ${cfg.persistPath} 0755 root root -"
    ];
  };
}
```

### Phase 6: Build System Improvements

#### 6.1 Enhanced Justfile
**Current Issue**: Justfile needs cleanup and improvements
**Improvements**:
```just
# Enhanced justfile with better error handling and documentation

set shell := ["bash", "-euo", "pipefail", "-c"]

# Default recipe shows available commands
default:
    @just --list --unsorted

# Build system for current host
rebuild target="":
    #!/usr/bin/env bash
    set -euo pipefail
    
    HOST=${1:-$(hostname)}
    echo "Building configuration for host: $HOST"
    
    # Pre-build checks
    just check-secrets
    just check-syntax
    
    # Build and switch
    if command -v nh &>/dev/null; then
        nh os switch . --hostname "$HOST" -- --impure
    else
        sudo nixos-rebuild switch --flake ".#$HOST" --impure
    fi
    
    # Post-build validation
    just validate-build

# Check flake syntax and evaluation
check-syntax:
    nix flake check --impure --keep-going

# Validate secrets are available
check-secrets:
    #!/usr/bin/env bash
    if [ ! -f "../nix-secrets/secrets.yaml" ]; then
        echo "ERROR: nix-secrets repository not found"
        exit 1
    fi

# Validate successful build
validate-build:
    #!/usr/bin/env bash
    echo "Validating build..."
    systemctl --failed | grep -q "0 loaded units" || {
        echo "WARNING: Some systemd units failed"
        systemctl --failed
    }

# Format all nix files
format:
    treefmt

# Update flake inputs
update:
    nix flake update
    git add flake.lock
    git commit -m "flake: update inputs" || true

# Generate ISO for installation
iso:
    nix build .#nixosConfigurations.iso.config.system.build.isoImage --impure
    ls -la result/iso/

# Deploy to remote host
deploy host:
    nixos-rebuild switch --flake ".#{{host}}" --target-host "{{host}}" --use-remote-sudo

# Clean up old generations
cleanup:
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
```

#### 6.2 Enhanced Script System
**Current Issue**: Bash scripts should be nixified
**Solution**: Convert to writeShellApplication
```nix
# pkgs/scripts/system-rebuild.nix
{ writeShellApplication, lib, nixos-rebuild, git, hostname, ... }:

writeShellApplication {
  name = "system-rebuild";
  
  runtimeInputs = [ nixos-rebuild git hostname ];
  
  text = ''
    set -euo pipefail
    
    # Color output functions
    red() { echo -e "\033[31m[!] $1\033[0m"; }
    green() { echo -e "\033[32m[+] $1\033[0m"; }
    yellow() { echo -e "\033[33m[*] $1\033[0m"; }
    
    HOST=''${1:-$(hostname)}
    
    green "Building configuration for host: $HOST"
    
    # Pre-build validation
    if ! git diff --exit-code >/dev/null; then
        yellow "Warning: Uncommitted changes detected"
    fi
    
    # Build system
    if nixos-rebuild switch --flake ".#$HOST" --impure; then
        green "Build successful for $HOST"
        
        # Tag successful build
        if git diff --exit-code >/dev/null; then
            BUILD_TAG="buildable-$(date +%Y%m%d%H%M%S)"
            git tag "$BUILD_TAG"
            green "Tagged build as $BUILD_TAG"
        fi
    else
        red "Build failed for $HOST"
        exit 1
    fi
  '';
}
```

### Phase 7: Testing and Validation

#### 7.1 Enhanced Checks
```nix
# checks.nix - Comprehensive validation
{ inputs, system, pkgs, ... }:
let
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      # Nix formatting and linting
      nixfmt.enable = true;
      deadnix.enable = true;
      
      # Shell script validation
      shellcheck.enable = true;
      shfmt.enable = true;
      
      # General formatting
      treefmt.enable = true;
      
      # Custom validation
      flake-check = {
        enable = true;
        name = "flake-check";
        entry = "${pkgs.nix}/bin/nix flake check --impure";
        language = "system";
        pass_filenames = false;
      };
    };
  };
  
  # Build tests for each host
  host-build-tests = pkgs.lib.mapAttrs (hostname: _: 
    pkgs.runCommand "test-${hostname}" {} ''
      echo "Testing build for ${hostname}"
      ${pkgs.nix}/bin/nix build .#nixosConfigurations.${hostname}.config.system.build.toplevel --dry-run
      touch $out
    ''
  ) (builtins.readDir ./hosts/nixos);
  
in
{
  inherit pre-commit-check;
} // host-build-tests
```

## Migration Strategy

### Step-by-Step Migration Plan

1. **Backup Current Configuration**
   ```bash
   # Create backup branch
   git checkout -b backup-before-refactor
   git push origin backup-before-refactor
   ```

2. **Create New Branch Structure**
   ```bash
   git checkout -b refactor-main
   mkdir -p {modules,lib,pkgs}/{common,nixos,darwin,home-manager}
   ```

3. **Migrate Core Systems First**
   - Start with lib/ and modules/common/
   - Move to basic host configurations
   - Add home-manager integration
   - Implement secrets management

4. **Gradual Host Migration**
   - Migrate one host at a time
   - Test thoroughly before moving to next
   - Keep old configuration as fallback

5. **Feature Addition**
   - Add new features incrementally
   - Test on single host before broad deployment
   - Document changes thoroughly

### Testing Strategy

1. **Local Testing**
   ```bash
   # Test flake evaluation
   nix flake check --impure
   
   # Test specific host build
   nix build .#nixosConfigurations.corais.config.system.build.toplevel
   
   # Test in VM
   nix run .#nixosConfigurations.test-vm
   ```

2. **Staged Deployment**
   - Test on non-critical host first
   - Verify all services work correctly
   - Check secrets are properly decrypted
   - Validate backups are functional

3. **Rollback Procedures**
   ```bash
   # Quick rollback to previous generation
   sudo nixos-rebuild switch --rollback
   
   # Or rollback to specific generation
   sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation 123
   ```

## Conclusion

This refactoring plan addresses all the major pain points identified in the TODO.md while providing a clear path for modernizing the nix-config architecture. The modular approach ensures that each component can be migrated and tested independently, reducing risk and allowing for incremental improvements.

Key benefits of this approach:
- **Better maintainability** through options-based modules
- **Reduced duplication** via enhanced specialArgs usage
- **Improved reliability** through nixified scripts
- **Enhanced security** with proper impermanence support
- **Better testing** with comprehensive validation

The migration can be done gradually, ensuring system stability throughout the process.