{
  agenix,
  microvm,
  nixpkgs, # stable for the microvm service
  nixpkgs-unstable, # unstable for the VM
  ...
}:
let
  runnerCapacity = 1;
  runnerLabels = [ "node" ];
  vCpus = 2;
  vRam = 3027;
in
{

}
