# Claude Code GitHub Actions Workflows

This directory contains GitHub Actions workflows that integrate Claude Code for automated code review, security analysis, and documentation verification.

## Prerequisites

Before using these workflows, you need to:

1. **Get an Anthropic API Key**
   - Sign up at [Anthropic Console](https://console.anthropic.com/)
   - Generate an API key from your account settings

2. **Add API Key to GitHub Secrets**
   - Go to your repository Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `ANTHROPIC_API_KEY`
   - Value: Your Anthropic API key
   - Click "Add secret"

## Available Workflows

### 1. PR Review (`claude-pr-review.yml`)

Basic automated PR review using Claude Code's built-in `/review` command.

**Triggers:** When PRs are opened, synchronized, or reopened

**Usage:**
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "/review"
    claude_args: "--max-turns 5"
```

### 2. Security Review (`claude-security-review.yml`)

Focused security analysis looking for common vulnerabilities.

**Triggers:** When PRs are opened or synchronized

**Focus Areas:**
- SQL injection
- XSS vulnerabilities
- Authentication flaws
- Data validation issues
- Sensitive data exposure

### 3. Code Quality Check (`claude-code-quality.yml`)

Comprehensive code quality review.

**Triggers:** PRs and manual workflow dispatch

**Checks:**
- Code smells and anti-patterns
- Refactoring opportunities
- Error handling
- Documentation quality
- Code style consistency

### 4. Documentation Review (`claude-documentation-review.yml`)

Specialized review for documentation changes.

**Triggers:** PRs affecting `.rst`, `.md`, or `.py` files in content directories

**Reviews:**
- Clarity and accuracy
- Code example correctness
- Formatting and structure
- Link validity
- Technical accuracy

## Configuration Options

### Basic Configuration

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Your instructions here"
    claude_args: "--max-turns 5"
```

### Advanced Configuration

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: |
      Multi-line prompt with detailed instructions:
      - Check for specific patterns
      - Follow project guidelines
      - Focus on particular areas
    claude_args: |
      --max-turns 10
      --model claude-sonnet-4-5-20250929
      --system-prompt "Follow our coding standards"
```

### Available Claude Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `--max-turns` | Maximum conversation turns | `--max-turns 10` |
| `--model` | Specific Claude model to use | `--model claude-sonnet-4-5-20250929` |
| `--system-prompt` | Additional system instructions | `--system-prompt "Use Python 3.11+"` |
| `--mcp-config` | MCP server configuration file | `--mcp-config /path/to/config.json` |

## Custom Workflows

### Example: Custom Task Review

```yaml
name: Custom Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  custom-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Custom Review with Claude Code
        uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: |
            Review this PR with focus on:
            1. Database migration safety
            2. API backward compatibility
            3. Performance implications
            4. Test coverage
          claude_args: |
            --max-turns 15
            --model claude-sonnet-4-5-20250929
```

## Permissions

The workflows require specific permissions:

```yaml
permissions:
  contents: read        # Read repository contents
  pull-requests: write  # Comment on PRs
  security-events: write # (Optional) For security workflows
```

## Best Practices

1. **Start with fewer turns** (`--max-turns 5`) and increase if needed
2. **Use specific prompts** for better, focused reviews
3. **Limit workflow triggers** to relevant file paths when possible
4. **Test workflows** on draft PRs before production use
5. **Monitor API usage** to stay within your Anthropic API limits
6. **Use workflow_dispatch** for manual testing and debugging

## Troubleshooting

### Workflow Not Running

- Check that `ANTHROPIC_API_KEY` is set in repository secrets
- Verify workflow permissions are correctly configured
- Ensure the trigger conditions match your PR

### API Rate Limits

- Reduce `--max-turns` to lower API usage
- Add path filters to limit when workflows run
- Use `workflow_dispatch` for manual control

### Review Quality

- Make prompts more specific and detailed
- Increase `--max-turns` for complex reviews
- Add `--system-prompt` with project-specific context
- Use the latest model for best results

## Examples from Other Projects

### Testing-Focused Review

```yaml
prompt: |
  Review test coverage and quality:
  - Verify all new code has tests
  - Check for edge cases
  - Ensure tests are maintainable
  - Validate test naming conventions
```

### Performance Review

```yaml
prompt: |
  Analyze performance implications:
  - Database query efficiency
  - Memory usage patterns
  - Algorithm complexity
  - Caching opportunities
```

### Accessibility Review

```yaml
prompt: |
  Review accessibility:
  - ARIA labels and roles
  - Keyboard navigation
  - Screen reader compatibility
  - Color contrast and visibility
```

## Learn More

- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Anthropic API Documentation](https://docs.anthropic.com/)
- [Claude Code CLI Reference](https://docs.claude.com/claude-code/cli)

## Support

For issues or questions:
- GitHub Issues: [odoo/documentation/issues](https://github.com/odoo/documentation/issues)
- Claude Code Issues: [anthropics/claude-code/issues](https://github.com/anthropics/claude-code/issues)
