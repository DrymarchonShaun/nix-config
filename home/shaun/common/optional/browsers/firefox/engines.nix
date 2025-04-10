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
    iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-logo-small.bae4361b.svg";
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
            value = "24.11";
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
            value = "24.11";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    iconUpdateURL = "https://nixos.wiki/favicon.png";
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
            value = "release-24.11";
          }
        ];
      }
    ];
    updateInterval = 24 * 60 * 60 * 1000; # every day
    definedAliases = [ "@hmopts" ];
  };
}
