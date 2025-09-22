# Refactored Nix-Config Template

This directory contains a template structure for the refactored nix-config, implementing the modern architecture described in the refactoring guide.

## Directory Structure

```
.
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Locked input versions
├── justfile                     # Build automation
├── treefmt.nix                  # Code formatting
├── checks.nix                   # Pre-commit and validation
├── shell.nix                    # Development shell
├── README.md                    # Documentation
├── lib/
│   └── default.nix             # Custom library functions
├── modules/
│   ├── common/                  # Cross-platform modules
│   │   ├── default.nix
│   │   └── host-spec.nix        # Host specification system
│   ├── nixos/                   # NixOS-specific modules
│   │   ├── default.nix
│   │   ├── desktop/             # Desktop environment modules
│   │   ├── development/         # Development tools
│   │   ├── gaming/              # Gaming support
│   │   ├── security/            # Security and secrets
│   │   └── system/              # System services
│   ├── darwin/                  # macOS-specific modules
│   └── home-manager/            # Home-manager modules
├── hosts/
│   ├── common/
│   │   ├── core/                # Required configurations
│   │   ├── optional/            # Optional configurations  
│   │   └── users/               # User definitions
│   ├── nixos/                   # NixOS host configurations
│   │   ├── corais/
│   │   ├── natrix/
│   │   └── iso/
│   └── darwin/                  # macOS host configurations
├── home/
│   └── [username]/
│       ├── common/
│       │   ├── core/            # Common home configurations
│       │   └── optional/        # Optional home configurations
│       └── [hostname].nix       # Host-specific home config
├── pkgs/
│   ├── common/                  # Cross-platform packages
│   ├── nixos/                   # Linux-specific packages
│   └── darwin/                  # macOS-specific packages
├── overlays/
│   └── default.nix             # Package overlays
├── scripts/                     # Nixified scripts
├── templates/                   # Project templates
└── docs/                        # Documentation
    ├── REFACTORING_GUIDE.md
    ├── INSTALLATION.md
    └── TROUBLESHOOTING.md
```

## Key Implementation Files

### Enhanced Flake Structure
The new flake.nix focuses on:
- Better specialArgs integration
- Dynamic host discovery
- Modular package management
- Comprehensive output structure

### Module System
All modules now follow a consistent pattern:
- Options-based configuration
- Feature flags for enablement
- Proper dependency management
- Clear documentation

### Host Specification
Enhanced hostSpec system providing:
- Hardware detection
- Role-based configuration
- Feature flag management
- Security settings

### Build System
Improved automation through:
- Nixified scripts
- Better error handling
- Comprehensive validation
- Easy deployment

## Usage

1. **Initialize new configuration**:
   ```bash
   # Copy template structure
   cp -r refactor-template/* /path/to/new-nix-config/
   cd /path/to/new-nix-config
   ```

2. **Configure hosts**:
   ```bash
   # Create host configuration
   mkdir hosts/nixos/my-host
   # Edit configuration files
   ```

3. **Build and test**:
   ```bash
   # Enter development shell
   nix develop
   
   # Check configuration
   just check-syntax
   
   # Build system
   just rebuild my-host
   ```

4. **Deploy**:
   ```bash
   # Deploy to remote host
   just deploy my-host
   ```

## Migration from Existing Config

1. **Backup current configuration**
2. **Map existing modules to new structure**
3. **Migrate secrets and keys**
4. **Test incrementally**
5. **Deploy gradually**

See REFACTORING_GUIDE.md for detailed migration instructions.