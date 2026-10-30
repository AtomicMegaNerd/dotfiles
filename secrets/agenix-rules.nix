let
  user = builtins.readFile ../static/rcd_pub_key;
  blahaj = builtins.readFile ../static/blahaj/blahaj_host_key;
in
{
  "starfeed-config.age".publicKeys = [
    user
    blahaj
  ];
  "cloudflare-ddns-token.age".publicKeys = [
    user
    blahaj
  ];
  "internal-tls-cert.age".publicKeys = [
    user
    blahaj
  ];
  "internal-tls-key.age".publicKeys = [
    user
    blahaj
  ];

  "beszel-agent.age".publicKeys = [
    user
    blahaj
  ];
  "forgejo-runner-token.age".publicKeys = [
    user
    blahaj
  ];
  "runner-beszel-agent.age".publicKeys = [
    user
    blahaj
  ];
  "restic-password.age".publicKeys = [
    user
    blahaj
  ];
}
