# Generate a rendered AGENTS.md / CLAUDE.md from the shared template.
#
# Usage:
#   let mkAgentsMd = import ./lib/agents-md.nix { inherit pkgs; };
#   in mkAgentsMd {
#     template = ../static/agents-template.md;
#     title = "Global Pi Agent Guidance";
#     context7Line = "";  # or "- Always try context7 first..."
#   }
#
# Returns a string (via IFD) — the HM modules accept this as `lines`
# in `either lines path` and will write it as the .md config file.
{ pkgs }:

{
  template,
  title,
  context7Line ? "",
}:

builtins.readFile (
  pkgs.replaceVars template {
    inherit title context7Line;
  }
)
