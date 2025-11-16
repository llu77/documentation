# Claude Code Configuration

This directory contains Claude Code configuration files and hooks for the Odoo documentation repository.

## Directory Structure

```
.claude/
├── README.md           # This file
└── hooks/              # Session hooks
    └── session-start.sh # Runs at session start
```

## Hooks

Hooks are shell scripts that run automatically at specific points in a Claude Code session. They help automate environment setup and ensure consistency across different development environments.

### Available Hooks

#### session-start.sh

Runs automatically when a Claude Code session starts. This hook:

- Detects if running in a remote environment (Claude Code on the web)
- Installs Python dependencies from `requirements.txt`
- Provides helpful information about available commands
- Skips installation in local environments to avoid conflicts

**Environment Variables:**

- `CLAUDE_CODE_REMOTE`: Set to `"true"` when running in Claude Code on the web
  - Use this to conditionally run setup only in remote environments
  - Local environments can skip automated setup

**Usage:**

The hook runs automatically - no manual action required. When you start a Claude Code session on the web, you'll see output like:

```
🚀 Starting Claude Code session setup...
🌐 Remote environment detected - installing dependencies...
📦 Installing Python dependencies from requirements.txt...
✅ Python dependencies installed successfully
✨ Session setup complete! Ready to work on Odoo documentation.
```

### Creating Custom Hooks

You can create additional hooks for other events. Supported hook types:

1. **session-start.sh** - Runs when session starts
2. **tool-call-prompt-submit.sh** - Runs when tool is called
3. **user-prompt-submit.sh** - Runs when user submits prompt

#### Example: Custom Session Start Hook

```bash
#!/bin/bash

# Only run in remote environments
if [ "$CLAUDE_CODE_REMOTE" != "true" ]; then
  exit 0
fi

# Your custom setup commands
echo "Setting up custom environment..."

# Install dependencies
pip install -r requirements.txt

# Configure git
git config --local user.name "Your Name"
git config --local user.email "your.email@example.com"

# Create necessary directories
mkdir -p temp_files

# Set environment variables
export PROJECT_ENV="development"

echo "Setup complete!"
```

#### Example: Tool Call Hook

```bash
#!/bin/bash
# .claude/hooks/tool-call-prompt-submit.sh

# Run linting before certain operations
if [[ "$CLAUDE_TOOL_NAME" == "Write" ]] || [[ "$CLAUDE_TOOL_NAME" == "Edit" ]]; then
  echo "Running pre-commit checks..."
  # Add your checks here
fi
```

### Hook Best Practices

1. **Exit early in local environments** - Use `CLAUDE_CODE_REMOTE` check
2. **Be idempotent** - Hooks should be safe to run multiple times
3. **Fail gracefully** - Don't block the session on non-critical failures
4. **Keep them fast** - Long-running hooks slow down session start
5. **Make them executable** - Run `chmod +x .claude/hooks/*.sh`
6. **Use set -e** - Exit on errors for critical setup steps
7. **Provide feedback** - Echo progress messages for visibility

### Debugging Hooks

If a hook is causing issues:

1. **Check hook output** - Hooks print to the Claude Code console
2. **Test locally** - Run the hook script manually:
   ```bash
   CLAUDE_CODE_REMOTE=true .claude/hooks/session-start.sh
   ```
3. **Add debug output** - Use `set -x` to trace execution:
   ```bash
   #!/bin/bash
   set -x  # Enable debug mode
   ```
4. **Disable temporarily** - Rename the hook to disable:
   ```bash
   mv session-start.sh session-start.sh.disabled
   ```

### Environment Variables Reference

Available environment variables in hooks:

| Variable | Description | Example |
|----------|-------------|---------|
| `CLAUDE_CODE_REMOTE` | Whether running remotely | `"true"` or not set |
| `CLAUDE_TOOL_NAME` | Tool being called (in tool hooks) | `"Write"`, `"Edit"`, `"Bash"` |
| `GITHUB_TOKEN` | GitHub token (if available) | `ghp_xxxxx...` |
| `PWD` | Current working directory | `/home/user/documentation` |

### Common Hook Patterns

#### Install Dependencies Only Once

```bash
#!/bin/bash

# Check if already installed
if [ -f ".dependencies_installed" ]; then
  echo "Dependencies already installed"
  exit 0
fi

# Install dependencies
pip install -r requirements.txt

# Mark as installed
touch .dependencies_installed
```

#### Conditional Setup Based on Files

```bash
#!/bin/bash

# Install Python dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
fi

# Install Node dependencies if package.json exists
if [ -f "package.json" ]; then
  npm install
fi

# Install Ruby dependencies if Gemfile exists
if [ -f "Gemfile" ]; then
  bundle install
fi
```

#### Environment-Specific Configuration

```bash
#!/bin/bash

if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  # Remote/cloud environment
  export DATABASE_URL="postgresql://remote-db:5432/app"
  export CACHE_ENABLED="true"
else
  # Local environment
  export DATABASE_URL="postgresql://localhost:5432/app_dev"
  export CACHE_ENABLED="false"
  export DEBUG="true"
fi
```

## Testing Hooks Locally

To test how hooks will behave in Claude Code on the web:

```bash
# Set the remote environment variable
export CLAUDE_CODE_REMOTE=true

# Run the hook
.claude/hooks/session-start.sh

# Unset when done
unset CLAUDE_CODE_REMOTE
```

## Learn More

- [Claude Code Hooks Documentation](https://docs.claude.com/claude-code/hooks)
- [Session Start Hook Guide](https://docs.claude.com/claude-code/hooks/session-start)
- [Environment Variables Reference](https://docs.claude.com/claude-code/environment)

## Troubleshooting

### Hook Not Running

- Verify hook is executable: `ls -la .claude/hooks/`
- Check hook filename matches expected pattern
- Ensure `.claude` directory is tracked in git (check `.gitignore`)

### Permission Denied

```bash
chmod +x .claude/hooks/*.sh
```

### Dependencies Not Installing

- Check internet connectivity in remote environment
- Verify `requirements.txt` exists and is valid
- Check hook output for error messages
- Ensure pip/npm/bundler is available

### Hook Slowing Down Session Start

- Move non-critical setup to background:
  ```bash
  pip install -r requirements.txt &
  ```
- Cache installed dependencies
- Only install what's necessary for Claude Code to work
