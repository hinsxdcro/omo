# OpenCode + Oh My OpenAgent Setup Guide

Team setup for OpenCode with Oh My OpenAgent plugin.

## TL;DR

Get your API keys from the internal AI proxy portal (ask the IT team for the link), then:

```bash
./setup.sh
```

Installs OpenCode and Oh My OpenAgent. Copies all configs from this repo. Prompts you for API base URLs and keys, then exports them to `~/.zshrc`:

```bash
export OPENAI_BASE_URL="<company-proxy-base-url>"
export OPENAI_API_KEY="<your-api-key>"
export ANTHROPIC_BASE_URL="<company-proxy-base-url>"
export ANTHROPIC_AUTH_TOKEN="<your-api-key>"
```

> Both pairs point at the same proxy — they are kept separate for compatibility
> with other tools (codex, claude-code, etc.).

The script covers all the steps below — only follow them if you prefer to set things up manually.

## Providers

The config defines two **custom providers** instead of the built-in `openai`/`anthropic` ones
(built-ins are disabled via `disabled_providers` so they can't auto-activate from env keys):

| Provider | Wire protocol | Models |
|---|---|---|
| `bedrock-openai` | OpenAI Responses API (`/v1/responses`) | `openai.gpt-5.6-sol`, `openai.gpt-5.6-terra`, `openai.gpt-5.6-luna` |
| `bedrock-anthropic` | Anthropic Messages API (`/v1/messages`) | `us.anthropic.claude-fable-5`, `us.anthropic.claude-sonnet-5`, `us.anthropic.claude-opus-4-8`, `us.anthropic.claude-haiku-4-5-20251001-v1:0` |

They cannot be merged into one provider: the proxy serves GPT models **only** on
`/v1/responses` and Claude models **only** on `/v1/messages`.

Model references always use the `provider/model` form, e.g.
`bedrock-anthropic/us.anthropic.claude-fable-5` or `bedrock-openai/openai.gpt-5.6-sol`.

Supported reasoning efforts (both providers): `low`, `medium`, `high`, `xhigh`, `max`.

## 1. Install OpenCode

```bash
# Check if already installed
opencode --version

# If not installed:
npm install -g opencode
```

## 2. Install Oh My OpenAgent

Run the installer — **choose any options it asks, it doesn't matter.** The config files from this repo will override everything.

```bash
bunx oh-my-openagent@latest install --no-tui --claude=no --gemini=no --copilot=no
```

Then copy configs from this repo:

```bash
# OpenCode config
cp .config/opencode/opencode.jsonc ~/.config/opencode/opencode.jsonc

# Oh My OpenAgent config
cp .config/opencode/oh-my-openagent.json ~/.config/opencode/oh-my-openagent.json
```

## 3. Configure Environment Variables

The config reads API credentials from environment variables. Add them to your `~/.zshrc`:

```bash
export OPENAI_BASE_URL="<company-proxy-base-url>"
export OPENAI_API_KEY="<your-api-key>"
export ANTHROPIC_BASE_URL="<company-proxy-base-url>"
export ANTHROPIC_AUTH_TOKEN="<your-api-key>"
```

Then reload: `source ~/.zshrc`

## 4. Verify

```bash
opencode --version

# Smoke-test each provider:
opencode run --model 'bedrock-anthropic/us.anthropic.claude-fable-5' 'what model are you?'
opencode run --model 'bedrock-openai/openai.gpt-5.6-sol' 'what model are you?'
```

## Quick Reference

| Config File | Location |
|---|---|
| OpenCode | `~/.config/opencode/opencode.jsonc` |
| Oh My OpenAgent | `~/.config/opencode/oh-my-openagent.json` |
| Environment variables | `~/.zshrc` |
