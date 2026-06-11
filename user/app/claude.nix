{
  pkgs,
  inputs,
  lib,
  ...
}: let
  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "694fa30311e02c2639942308513555e61ee84a6f";
    hash = "sha256-NGRKdnHSBKoR48zGotmJ3zGXnQ58ogudv8T4Va/2DSY=";
  };
  context7WithKey = pkgs.writeShellScriptBin "context7-mcp" ''
    read -r _k < /run/secrets/context7_api_key
    export CONTEXT7_API_KEY="$_k"
    exec ${pkgs.context7-mcp}/bin/context7-mcp "$@"
  '';
in {
  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;

    marketplaces = {
      claude-plugins-official = inputs.claude-plugins-official;
      dotclaude = inputs.dotclaude;
    };

    skills = {
      grill-me = "${mattpocock-skills}/skills/productivity/grill-me";
      handoff = "${mattpocock-skills}/skills/productivity/handoff";
      grill-with-docs = "${mattpocock-skills}/skills/engineering/grill-with-docs";
      improve-codebase-architecture = "${mattpocock-skills}/skills/engineering/improve-codebase-architecture";
    };

    mcpServers = {
      context7 = {
        command = "${context7WithKey}/bin/context7-mcp";
        args = [];
      };
      playwright = {
        command = "${pkgs.playwright-mcp}/bin/playwright-mcp";
        args = [];
      };
      serena = {
        command = "${pkgs.serena-mcp}/bin/serena-mcp";
        args = [];
      };
    };

    settings = {
      theme = "dark";
      enabledPlugins = {
        "claude-md-management@claude-plugins-official" = true;
        "hookify@claude-plugins-official" = true;
        "context7@claude-plugins-official" = true;
        "playwright@claude-plugins-official" = true;
        "setupdotclaude@dotclaude" = true;
        "remember@claude-plugins-official" = true;
        "superpowers@claude-plugins-official" = true;
      };
    };
  };
}
