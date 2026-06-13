#!/usr/bin/env bash
set -euo pipefail

# Apply fork-specific shell customizations
# Excludes: API keys, dotfiles alias, Claude Code env vars (personal)

# Set default editor
if ! grep -q 'export EDITOR=nano' "$HOME/.bashrc" 2>/dev/null; then
  echo '' >> "$HOME/.bashrc"
  echo '# Default editor (from fork config)' >> "$HOME/.bashrc"
  echo 'export EDITOR=nano' >> "$HOME/.bashrc"
fi

# Atuin shell history (if installed)
if command -v atuin &>/dev/null; then
  if ! grep -q 'atuin init' "$HOME/.zshrc" 2>/dev/null; then
    echo '' >> "$HOME/.zshrc"
    echo '# Atuin shell history (from fork config)' >> "$HOME/.zshrc"
    echo 'eval "$(atuin init zsh)"' >> "$HOME/.zshrc"
  fi
fi

# Custom keybindings for zsh
if ! grep -q 'beginning-of-line' "$HOME/.zshrc" 2>/dev/null; then
  cat >> "$HOME/.zshrc" << 'EOKEYS'
# Custom keybindings (from fork config)
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[Od' backward-word
bindkey '^[Oc' forward-word
EOKEYS
fi

echo "Shell customizations applied (EDITOR=nano, atuin, keybindings)"
