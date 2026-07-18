{
  lib,
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Chris Dunphy";
        email = "chris@megaparsec.ca";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      credential = {
        helper = "manager";
        "https://github.com".username = "AtomicMegaNerd";
        credentialStore = "cache";
      };

      # Setup Signing for 1Password if this is for macOS
      signing = lib.optionalAttrs config.isMac {
        format = "ssh";
        key = builtins.readFile ../static/rcd_pub_key;
      };
      gpg.ssh.allowedSignersFile = lib.mkIf config.isMac "~/.ssh/allowed_signers";
    };
  };
}
