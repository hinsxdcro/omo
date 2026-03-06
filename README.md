# OpenCode + Oh My OpenCode Setup Guide

Team setup for OpenCode with Oh My OpenCode plugin and OCMonitor.

## TL;DR

```bash
./setup.sh
```

Installs OpenCode, Oh My OpenCode, and OCMonitor. Copies all configs from this repo. Prompts you for API base URLs and keys, then exports them to `~/.zshrc`.

## Prerequisites

- Node.js 18+
- macOS or Linux
- Have the following ready before you start:

| Variable | Description |
|---|---|
| `OPENAI_BASEURL` | OpenAI-compatible API base URL |
| `OPENAI_API_KEY` | OpenAI API key |
| `ANTHROPIC_BASEURL` | Anthropic-compatible API base URL |
| `ANTHROPIC_AUTH_TOKEN` | Anthropic API key |

> Ask the IT team if you don't have these.

## 1. Install OpenCode

```bash
# Check if already installed
opencode --version

# If not installed:
npm install -g opencode
```

## 2. Install Oh My OpenCode

Run the installer — **choose any options it asks, it doesn't matter.** The config files from this repo will override everything.

```bash
npx oh-my-opencode@latest init
```

Then copy configs from this repo:

```bash
# OpenCode config
cp .config/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc

# Oh My OpenCode config
cp .config/opencode/oh-my-opencode.json ~/.config/opencode/oh-my-opencode.json
```

## 3. Configure Environment Variables

The config reads API credentials from environment variables. Add them to your `~/.zshrc`:

```bash
export OPENAI_BASEURL="<your-openai-base-url>"
export OPENAI_API_KEY="<your-openai-api-key>"
export ANTHROPIC_BASEURL="<your-claude-base-url>"
export ANTHROPIC_AUTH_TOKEN="<your-claude-api-key>"
```

Then reload: `source ~/.zshrc`

## 4. Install OpenCode Monitor

Install `uv` first (fast Python package manager), then install OCMonitor:

```bash
# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install OCMonitor
uv tool install git+https://github.com/Shlomob/ocmonitor-share.git

# Copy model pricing config
mkdir -p ~/.config/ocmonitor
cp .config/ocmonitor/models.json ~/.config/ocmonitor/models.json
```

## 5. Verify

```bash
opencode --version
ocmonitor config show
```

## Quick Reference

| Config File | Location |
|---|---|
| OpenCode | `~/.config/opencode/opencode.jsonc` |
| Oh My OpenCode | `~/.config/opencode/oh-my-opencode.json` |
| OCMonitor models | `~/.config/ocmonitor/models.json` |
| Environment variables | `~/.zshrc` |

## Caveats

- **OCMonitor input token counts unavailable for our custom Anthropic models.** The proxy does not return input token usage for these models, so OCMonitor cost tracking will be incomplete. Contact the IT team for further help.
