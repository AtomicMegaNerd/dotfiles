{ pkgs, ... }:

{
  enable = true;
  signing = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
    format = "ssh";
    key = builtins.readFile ../static/rcd_pub_key;
  };
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
    gpg.ssh.allowedSignersFile = pkgs.lib.mkIf pkgs.stdenv.isDarwin "~/.ssh/allowed_signers";
  };
}
