#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "usage: $0 <timeout> [<workdir>] <prompt-file> <events-log>" >&2
  exit 2
}

case $# in
  3)
    duration=$1
    workdir=$PWD
    prompt_file=$2
    events_log=$3
    ;;
  4)
    duration=$1
    workdir=$2
    prompt_file=$3
    events_log=$4
    ;;
  *)
    usage
    ;;
esac

if [[ ! -d "$workdir" ]]; then
  echo "Pi working directory does not exist: $workdir" >&2
  exit 2
fi
workdir="$(cd "$workdir" && pwd -P)"

resolve_from_workdir() {
  local path=$1
  if [[ "$path" = /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$workdir" "$path"
  fi
}

prompt_file="$(resolve_from_workdir "$prompt_file")"
events_log="$(resolve_from_workdir "$events_log")"

if [[ ! -f "$prompt_file" ]]; then
  echo "Pi prompt file does not exist: $prompt_file" >&2
  exit 2
fi
command -v pi >/dev/null || { echo "pi is not installed" >&2; exit 2; }
command -v jq >/dev/null || { echo "jq is not installed" >&2; exit 2; }

umask 077
mkdir -p "$(dirname "$events_log")"

(
  cd "$workdir"
  timeout "$duration" pi --no-session --mode json -p "$(<"$prompt_file")"
) |
  jq --unbuffered -c '
    def clip($n):
      tostring |
      if length > $n then .[0:$n] + "..." else . end;

    if .type == "tool_execution_start" then
      if .toolName == "bash" then
        {e:"bash", cmd:((.args.command // "") | clip(180))}
      elif (.toolName == "edit" or .toolName == "write") then
        {e:.toolName, path:(.args.path // "")}
      elif .toolName == "read" then
        empty
      else
        {e:"tool", tool:.toolName}
      end
    elif .type == "tool_execution_end" and .isError then
      {e:"tool_error", tool:.toolName}
    elif .type == "message_update"
         and .assistantMessageEvent.type == "text_end" then
      {e:"progress",
       text:((.assistantMessageEvent.content // "") | clip(500))}
    elif .type == "auto_retry_start" then
      {e:"retry", attempt, maxAttempts,
       errorMessage:((.errorMessage // "") | clip(300))}
    elif (.type == "compaction_start" or .type == "compaction_end") then
      {e:.type, reason}
    elif .type == "agent_end" then
      {e:"agent_end", willRetry:(.willRetry // false)}
    elif .type == "agent_settled" then
      {e:"settled"}
    else
      empty
    end
  ' | tee "$events_log"
