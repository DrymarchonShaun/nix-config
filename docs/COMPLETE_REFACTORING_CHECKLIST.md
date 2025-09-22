# Complete Nix-Config Refactoring Checklist

## 🚀 Quick Start Summary

**Estimated Timeline**: 4-6 weeks for complete refactor
**Risk Level**: Medium (gradual migration possible)
**Current Codebase**: 184 .nix files, well-structured foundation

## 📋 Phase-by-Phase Checklist

### Phase 1: Foundation (Week 1)
- [ ] **Project Setup**
  - [ ] Create backup branch (`git checkout -b backup-before-refactor`)
  - [ ] Create refactor branch (`git checkout -b refactor-v2`)
  - [ ] Set up new directory structure
  - [ ] Initialize flake.nix with modern architecture

- [ ] **Core Infrastructure**
  - [ ] Enhance lib/default.nix with helper functions
  - [ ] Create modules/common/host-spec.nix with options system
  - [ ] Set up overlays/default.nix for package management
  - [ ] Configure treefmt.nix for code formatting
  - [ ] Implement checks.nix for validation

### Phase 2: Module System (Week 1-2)
- [ ] **Common Modules**
  - [ ] modules/common/default.nix - Core module loader
  - [ ] modules/common/host-spec.nix - Host specification system
  - [ ] modules/common/users.nix - User management

- [ ] **NixOS Modules** (Convert existing to options-based)
  - [ ] modules/nixos/desktop/ - Desktop environments (Hyprland, Sway)
  - [ ] modules/nixos/security/ - SOPS, YubiKey, fail2ban
  - [ ] modules/nixos/development/ - Development tools
  - [ ] modules/nixos/gaming/ - Steam, gaming hardware
  - [ ] modules/nixos/system/ - Core system services
  - [ ] modules/nixos/virtualization/ - Containers, VMs

- [ ] **Home Manager Modules**
  - [ ] modules/home-manager/shell/ - Zsh, Fish configurations
  - [ ] modules/home-manager/desktop/ - Window manager configs
  - [ ] modules/home-manager/development/ - Editor configs
  - [ ] modules/home-manager/media/ - Media applications

### Phase 3: Host Configuration (Week 2)
- [ ] **Common Host Configuration**
  - [ ] hosts/common/core/default.nix - Core requirements
  - [ ] hosts/common/core/nixos.nix - NixOS specifics
  - [ ] hosts/common/core/sops.nix - Secrets management
  - [ ] hosts/common/optional/ - Optional features

- [ ] **Individual Host Migration**
  - [ ] hosts/nixos/corais/ - Main desktop
  - [ ] hosts/nixos/natrix/ - Laptop
  - [ ] hosts/nixos/getula/ - Server
  - [ ] hosts/nixos/iso/ - Installation ISO

### Phase 4: User Configuration (Week 2-3)
- [ ] **User Management**
  - [ ] hosts/common/users/primary/ - Main user setup
  - [ ] hosts/common/users/media/ - Media user
  - [ ] SSH key management system

- [ ] **Home Manager Integration**
  - [ ] home/shaun/common/core/ - Core user config
  - [ ] home/shaun/common/optional/ - Optional features
  - [ ] home/shaun/corais.nix - Desktop home config
  - [ ] home/shaun/natrix.nix - Laptop home config

### Phase 5: Advanced Features (Week 3-4)
- [ ] **Storage & Security**
  - [ ] Disko configurations for declarative partitioning
  - [ ] Impermanence implementation
  - [ ] Enhanced SOPS with per-host keys
  - [ ] Backup system integration

- [ ] **Build System**
  - [ ] Enhanced justfile with error handling
  - [ ] Nixified scripts (replace bash scripts)
  - [ ] ISO building automation
  - [ ] Deploy scripts for remote hosts

- [ ] **Custom Packages**
  - [ ] pkgs/common/ - Cross-platform packages
  - [ ] Package overlay integration
  - [ ] Custom package automation

### Phase 6: Testing & Validation (Week 4)
- [ ] **Comprehensive Testing**
  - [ ] Flake evaluation tests
  - [ ] Per-host build validation
  - [ ] Home-manager integration tests
  - [ ] Secrets decryption validation

- [ ] **Quality Assurance**
  - [ ] Pre-commit hooks setup
  - [ ] Code formatting validation
  - [ ] Documentation completeness
  - [ ] Migration testing on test host

### Phase 7: Documentation (Week 4-5)
- [ ] **User Documentation**
  - [ ] Updated README.md with new architecture
  - [ ] Installation guide for new structure
  - [ ] Troubleshooting documentation
  - [ ] Feature documentation

- [ ] **Developer Documentation**
  - [ ] Module development guide
  - [ ] Contribution guidelines
  - [ ] Architecture decision records
  - [ ] Migration procedures

### Phase 8: Migration & Deployment (Week 5-6)
- [ ] **Gradual Migration**
  - [ ] Test deployment on least critical host
  - [ ] Validate all services function correctly
  - [ ] Migrate secrets and keys
  - [ ] Deploy to remaining hosts

- [ ] **Final Integration**
  - [ ] Update nix-secrets repository
  - [ ] Set up automated updates
  - [ ] Configure monitoring
  - [ ] Create rollback procedures

## 🔧 Technical Implementation Details

### Current Architecture Analysis
**Strengths to Preserve:**
- Good flake structure (235 lines, well organized)
- Comprehensive hostSpec system
- Working SOPS integration
- Custom package system (21 packages)
- Automation via justfile

**Issues to Address:**
- Need options-based modules (from TODO.md)
- Extensive specialArgs usage needed
- Script quality improvements (nixify bash)
- Impermanence implementation
- Module duplication reduction

### Key Code Examples

#### Enhanced Module Pattern
```nix
# modules/nixos/gaming.nix
{ config, lib, pkgs, ... }:
let cfg = config.mySystem.gaming;
in {
  options.mySystem.gaming = {
    enable = lib.mkEnableOption "gaming support";
    steam.enable = lib.mkEnableOption "Steam";
    hardware.controllers = lib.mkEnableOption "controller support";
  };
  
  config = lib.mkIf cfg.enable {
    programs.steam.enable = cfg.steam.enable;
    services.udev.packages = lib.optionals cfg.hardware.controllers [
      pkgs.xpadneo
    ];
  };
}
```

#### Enhanced HostSpec
```nix
# Enhanced host specification
hostSpec = {
  hostName = "corais";
  role = "desktop";
  hardware = {
    cpu = "amd";
    gpu = "amd";
  };
  features = {
    gaming = true;
    development = true;
  };
  security = {
    yubikey = true;
    secureBoot = false;
  };
};
```

#### Nixified Scripts
```nix
# pkgs/scripts/system-rebuild.nix
writeShellApplication {
  name = "system-rebuild";
  runtimeInputs = [ nixos-rebuild git ];
  text = ''
    set -euo pipefail
    HOST=''${1:-$(hostname)}
    nixos-rebuild switch --flake ".#$HOST" --impure
  '';
}
```

## 🎯 Success Criteria

### Functionality Parity
- [ ] All current hosts build successfully
- [ ] All services start correctly
- [ ] Secrets decrypt properly
- [ ] User environments work identically

### Architecture Improvements
- [ ] All modules use options system
- [ ] No hardcoded paths or values
- [ ] Consistent error handling
- [ ] Comprehensive documentation

### Maintainability Goals
- [ ] Easy to add new hosts
- [ ] Simple feature flag management
- [ ] Clear module boundaries
- [ ] Automated testing

## 🚨 Risk Mitigation

### Backup Strategy
1. Git branch with current working config
2. Full system backup before migration
3. Secrets backup in separate location
4. Hardware configuration preservation

### Rollback Plan
1. Keep old generation available
2. Document rollback procedures
3. Test rollback on non-critical host
4. Maintain emergency recovery ISO

### Testing Strategy
1. Test each phase incrementally
2. Validate on test host first
3. Check all critical services
4. Verify secrets and authentication

## 📈 Timeline & Resources

**Week 1-2: Foundation & Modules**
- Focus: Core architecture, module system
- Risk: Low, mostly refactoring
- Validation: Flake checks, module tests

**Week 3-4: Integration & Features** 
- Focus: Host configs, advanced features
- Risk: Medium, system changes
- Validation: Test host deployment

**Week 5-6: Migration & Documentation**
- Focus: Production deployment
- Risk: Medium, live system changes
- Validation: Full functionality testing

**Total Effort**: ~40-60 hours
**Skills Required**: Nix, system administration
**Dependencies**: Access to all target hosts

## 🎉 Expected Benefits

**Immediate:**
- Cleaner, more maintainable code
- Better error messages and debugging
- Consistent configuration patterns

**Long-term:**
- Easier host additions
- Better testing and validation
- Improved security posture
- Enhanced automation capabilities

This refactoring will transform the nix-config from a good personal configuration into an exemplary, maintainable system that can serve as a reference for others while being much easier to extend and maintain.