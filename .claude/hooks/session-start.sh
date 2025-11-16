#!/bin/bash

# Session Start Hook for Odoo Documentation
# This script runs when a Claude Code session starts
# It sets up the environment with required dependencies

set -e  # Exit on error

echo "🚀 Starting Claude Code session setup..."

# Only run in remote environments (Claude Code on the web)
# Skip for local development where dependencies may already be installed
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  echo "ℹ️  Running locally - skipping automated dependency installation"
  echo "   To install manually, run: pip install -r requirements.txt"
  exit 0
fi

echo "🌐 Remote environment detected - installing dependencies..."

# Check if Python is available
if ! command -v python3 &> /dev/null; then
  echo "❌ Python 3 not found. Please ensure Python is installed."
  exit 1
fi

# Install Python dependencies for Sphinx documentation build
if [ -f "requirements.txt" ]; then
  echo "📦 Installing Python dependencies from requirements.txt..."
  pip install --quiet -r requirements.txt
  echo "✅ Python dependencies installed successfully"
else
  echo "⚠️  requirements.txt not found - skipping Python dependencies"
fi

# Optional: Install additional tools if needed
# Uncomment the following lines if you need additional setup

# Install Node.js dependencies if package.json exists
# if [ -f "package.json" ]; then
#   echo "📦 Installing Node.js dependencies..."
#   npm install --quiet
#   echo "✅ Node.js dependencies installed"
# fi

# Set up git configuration for the session
# git config --local user.name "Claude Code Bot" || true
# git config --local user.email "claude-code@anthropic.com" || true

echo "✨ Session setup complete! Ready to work on Odoo documentation."
echo ""
echo "📚 Available commands:"
echo "   make html      - Build HTML documentation"
echo "   make help      - Show all available make commands"
echo "   make clean     - Clean build files"
echo ""
