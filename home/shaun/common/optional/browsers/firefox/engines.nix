{
  "Brave Search" = {
    urls = [
      {
        template = "https://search.brave.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.bae4361b.svg";
    updateInterval = 24 * 60 * 60 * 1000; # every day
    definedAliases = [ "@br" ];
  };
  "Nix Packages" = {
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "channel";
            value = "25.05";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "@nixpkgs" ];
  };
  "Nix Options" = {
    urls = [
      {
        template = "https://search.nixos.org/options";
        params = [
          {
            name = "channel";
            value = "25.05";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "https://nixos.wiki/favicon.png";
    updateInterval = 24 * 60 * 60 * 1000; # every day
    definedAliases = [ "@nixopts" ];
  };
  "Home Manager Options" = {
    urls = [
      {
        template = "https://home-manager-options.extranix.com/?";
        params = [
          {
            name = "query";
            value = "{searchTerms}";
          }
          {
            name = "release";
            value = "release-25.05";
          }
        ];
      }
    ];
    updateInterval = 24 * 60 * 60 * 1000; # every day
    definedAliases = [ "@hmopts" ];
  };
}
