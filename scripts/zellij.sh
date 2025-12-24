#!/bin/bash

SESSION_NAME="dotfiles"

set -e

# Try to attach to an existing session; if it doesn't exist, create a new one with the specified
# layout.
if zellij list-sessions 2>/dev/null | awk '{print $1}' | grep -Fq "${SESSION_NAME}"; then
	echo "Attaching to existing Zellij session: ${SESSION_NAME}"
	zellij attach "${SESSION_NAME}"
else
	echo "Creating new Zellij session: ${SESSION_NAME}"
	zellij --new-session-with-layout "./.zellij/${SESSION_NAME}.kdl" --session "${SESSION_NAME}"
fi
