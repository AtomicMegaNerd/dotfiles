{ pkgs }: {
  enable = true;
  config = { theme = "catppuccin-frappe"; };
  themes = {
    catppuccin-frappe = {
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
        hash = "sha256-Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
      };
      file = "/themes/Catppuccin Frappe.tmTheme";
    };
  };
}
