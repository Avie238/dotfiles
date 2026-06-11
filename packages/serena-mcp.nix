{
  writeShellScriptBin,
  uv,
}:
writeShellScriptBin "serena-mcp" ''
  exec ${uv}/bin/uvx serena-agent==1.5.3 start-mcp-server --context ide-assistant "$@"
''
