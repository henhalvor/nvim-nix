
#!/usr/bin/env bash

# Path to your actual (mutable) Neovim config
SOURCE_DIR="$HOME/.nvim-nix/config"
TARGET_DIR="$HOME/.config/nvim"

echo "Linking Neovim config..."
echo "Source: $SOURCE_DIR"
echo "Target: $TARGET_DIR"

# Ensure the source exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

# Remove the existing target if it exists
if [ -L "$TARGET_DIR" ] || [ -d "$TARGET_DIR" ]; then
  echo "Removing existing target at '$TARGET_DIR'"
  rm -rf "$TARGET_DIR"
fi

# Create the symlink
ln -s "$SOURCE_DIR" "$TARGET_DIR"
echo "Symlink created."

exit 0
