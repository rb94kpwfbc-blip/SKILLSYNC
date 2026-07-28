#!/bin/zsh

set -e

SCRIPT_DIRECTORY="${0:A:h}"
cd "$SCRIPT_DIRECTORY"

echo ""
echo "SkillSync AI Tutor"
echo "Your API key is used only in this Terminal window and is not saved."
echo ""

if [[ -z "$OPENAI_API_KEY" ]]; then
  read -rs "OPENAI_API_KEY?Paste your OpenAI API key, then press Return: "
  echo ""
  export OPENAI_API_KEY
fi

if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "No API key was entered."
  read "?Press Return to close this window."
  exit 1
fi

exec /usr/bin/python3 "$SCRIPT_DIRECTORY/tutor_server.py"
