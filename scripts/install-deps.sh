#!/usr/bin/env bash

set -e

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Updating Homebrew..."
brew update

# Check if Supabase CLI is installed
if brew list supabase/tap/supabase &>/dev/null; then
  echo "Upgrading Supabase CLI..."
  brew upgrade supabase
else
  echo "Installing Supabase CLI..."
  brew install supabase/tap/supabase
fi

echo "Supabase CLI is now up to date!"