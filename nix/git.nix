{
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
  };
}
