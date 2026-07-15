let
  user = builtins.readFile ../static/rcd_pub_key;
  blahaj = builtins.readFile ../static/blahaj_host_key;
in
{
  "starfeed-env.age".publicKeys = [
    user
    blahaj
  ];
  "starfeed-config.age".publicKeys = [
    user
    blahaj
  ];
  "cloudflare-ddns-token.age".publicKeys = [
    user
    blahaj
  ];
}
