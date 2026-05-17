let
  user = builtins.readFile ../static/rcd_pub_key;
  blahaj = builtins.readFile ../static/blahaj_host_key;
in
{
  "duckdns-token.age".publicKeys = [
    user
    blahaj
  ];
  "starfeed-env.age".publicKeys = [
    user
    blahaj
  ];
}
