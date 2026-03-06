#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC="$HOME/.zshrc"

echo "=== OpenCode + Oh My OpenCode Setup ==="
echo ""

# ─── 1. Collect API credentials ─────────────────────────────────────────────
# These get written to ~/.zshrc so OpenCode can read them via {env:...}
# Press Enter to skip any value — existing entries in ~/.zshrc will be kept.

echo "Before we start, we need your API credentials."
echo "Ask the IT team if you don't have these."
echo "Press Enter to skip — existing values in ~/.zshrc won't be overwritten."
echo ""

read -rp "OPENAI_BASEURL  (OpenAI-compatible base URL): " OPENAI_BASEURL
read -rp "OPENAI_API_KEY  (OpenAI API key):             " OPENAI_API_KEY
read -rp "ANTHROPIC_BASEURL  (Anthropic-compatible base URL): " ANTHROPIC_BASEURL
read -rp "ANTHROPIC_API_KEY  (Anthropic API key):           " ANTHROPIC_API_KEY

  echo ""

# ─── 2. Write env vars to ~/.zshrc ──────────────────────────────────────────
# Only update values that were provided. Empty input = keep existing.

touch "$ZSHRC"
ENV_UPDATED=0

for VAR_NAME in OPENAI_BASEURL OPENAI_API_KEY ANTHROPIC_BASEURL ANTHROPIC_API_KEY; do
  VAR_VALUE="${!VAR_NAME}"
  if [[ -n "$VAR_VALUE" ]]; then
    sed -i '' "/^export ${VAR_NAME}=/d" "$ZSHRC" 2>/dev/null || true
    echo "export ${VAR_NAME}=\"${VAR_VALUE}\"" >> "$ZSHRC"
    export "${VAR_NAME}"
    echo "  ✓ ${VAR_NAME} updated"
    ENV_UPDATED=1
  else
    echo "  – ${VAR_NAME} skipped (keeping existing)"
  fi
done

if [[ $ENV_UPDATED -eq 1 ]]; then
  echo ""
  echo "✓ Environment variables saved to $ZSHRC"
else
  echo ""
  echo "– No environment variables changed"
fi
echo ""

# ─── 3. Check/Install OpenCode ──────────────────────────────────────────────

if command -v opencode &>/dev/null; then
  echo "✓ OpenCode already installed: $(opencode --version)"
else
  echo "Installing OpenCode..."
  npm install -g opencode
  echo "✓ OpenCode installed"
fi

echo ""

# ─── 4. Install Oh My OpenCode ──────────────────────────────────────────────
# NOTE: The installer will ask you interactive questions.
#       Choose whatever you want — the config from this repo overrides everything.

echo "Installing Oh My OpenCode..."
echo "  → Choose any options during the setup — our config will override them."
echo ""
bunx oh-my-opencode@latest install --no-tui --claude=no --gemini=no --copilot=no

echo ""

# ─── 5. Copy configs from this repo ─────────────────────────────────────────

echo "Copying configs..."

mkdir -p ~/.config/opencode
mkdir -p ~/.config/ocmonitor

cp "$SCRIPT_DIR/.config/opencode/opencode.jsonc" ~/.config/opencode/opencode.jsonc
cp "$SCRIPT_DIR/.config/opencode/oh-my-opencode.json" ~/.config/opencode/oh-my-opencode.json
cp "$SCRIPT_DIR/.config/ocmonitor/models.json" ~/.config/ocmonitor/models.json

echo "✓ Configs copied"
echo ""

# ─── 6. Install uv + OCMonitor ──────────────────────────────────────────────

if command -v uv &>/dev/null; then
  echo "✓ uv already installed"
else
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
  echo "✓ uv installed"
fi

if command -v ocmonitor &>/dev/null; then
  echo "✓ OCMonitor already installed"
else
  echo "Installing OCMonitor..."
  uv tool install git+https://github.com/Shlomob/ocmonitor-share.git
  echo "✓ OCMonitor installed"
fi

echo ""

# ─── Done ────────────────────────────────────────────────────────────────────

echo "=== Setup Complete ==="
echo ""
echo "Run 'source ~/.zshrc' or open a new terminal, then verify with:"
echo "   opencode --version"
echo "   ocmonitor config show"
