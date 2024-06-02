- Plymouth
- Rofi
- Gradience
- waybar
- mpd?
- email sops (git)
- openbooks
- custom packagesi


#### Sway ?????

nvim space/<leader>???


- polkit
- avahi
- bluetooth
- dconf
- gvfs
- gpg-agent?
- hyprlock?
- waybar


#### 24.05 update
```
trace: warning: shaun profile: The option `colorschemes.catppuccin.integrations' defined in `/nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/nixvim' has been renamed to `colorschemes.catppuccin.settings.integrations'.
trace: warning: shaun profile: The option `colorschemes.catppuccin.transparentBackground' defined in `/nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/nixvim' has been renamed to `colorschemes.catppuccin.settings.transparent_background'.
trace: warning: shaun profile: The option `colorschemes.catppuccin.flavour' defined in `/nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/nixvim' has been renamed to `colorschemes.catppuccin.settings.flavour'.
trace: warning: shaun profile: The option `options' defined in `/nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/nixvim' has been renamed to `opts'.
trace: warning: shaun profile: Nixvim (keymaps): the `lua` keymap option is deprecated.

This option will be removed in 24.11. You should use a "raw" `action` instead;
e.g. `action.__raw = "<lua code>"` or `action = helpers.mkRaw "<lua code>"`.

Found 1 use in /nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/nixvim:
[
  {
    action = ''
      function()
                require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end'';
    key = "<leader>be";
    lua = true;
    mode = [
      "n"
    ];
    options = {
      desc = "Buffer Explorer";
    };
  }
]


trace: warning: shaun profile: The option `programs.zsh.enableAutosuggestions' defined in `/nix/store/5sgzcmm7s3w8rhy9br4qhsgmpxp4xm0p-source/home/shaun/common/core/zsh' has been renamed to `programs.zsh.autosuggestion.enable'.
trace: warning: shaun profile: The option `qt.platformTheme` has been renamed to `qt.platformTheme.name`.
trace: warning: The user 'root' has multiple of the options
`hashedPassword`, `password`, `hashedPasswordFile`, `initialPassword`
& `initialHashedPassword` set to a non-null value.
The options silently discard others by the order of precedence
given above which can lead to surprising results. To resolve this warning,
set at most one of the options above to a non-`null` value.

trace: warning: The user 'shaun' has multiple of the options
`hashedPassword`, `password`, `hashedPasswordFile`, `initialPassword`
& `initialHashedPassword` set to a non-null value.
The options silently discard others by the order of precedence
given above which can lead to surprising results. To resolve this warning,
set at most one of the options above to a non-`null` value.```
