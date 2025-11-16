# Claude Code Slash Commands

This directory contains custom slash commands for Claude Code. These commands provide quick access to common tasks and reviews.

## Available Commands

### /review-pr
Comprehensive PR review covering code quality, documentation, security, and best practices.

**Usage:**
```bash
/review-pr
```

**What it checks:**
- Documentation quality and RST formatting
- Code examples completeness and correctness
- Technical accuracy for Odoo framework
- Security issues in examples
- Best practices compliance

### /security-check
Security-focused review checking for vulnerabilities and security best practices.

**Usage:**
```bash
/security-check
```

**What it checks:**
- OWASP Top 10 vulnerabilities
- Input validation
- SQL injection risks
- XSS protection
- Authentication/authorization
- Sensitive data exposure
- API security

### /doc-quality
Documentation quality and clarity review.

**Usage:**
```bash
/doc-quality
```

**What it checks:**
- Clarity and readability
- Completeness
- Structure and organization
- Code examples
- RST formatting
- Consistency
- Technical accuracy

### /perf-check
Performance review identifying bottlenecks and optimization opportunities.

**Usage:**
```bash
/perf-check
```

**What it checks:**
- Database queries and N+1 problems
- Algorithm efficiency
- Memory usage
- Caching opportunities
- I/O operations
- Data structure usage

## Creating Custom Commands

### Command File Structure

Create a new `.md` file in this directory:

```markdown
---
description: Brief description shown in command list
---

Your command prompt here.

This becomes the instructions that Claude receives when you run the command.
```

### Example

Create `.claude/commands/my-command.md`:

```markdown
---
description: Check for Python best practices
---

Review the Python code in this repository for:
1. PEP 8 compliance
2. Type hints usage
3. Docstring quality
4. Error handling
5. Testing coverage

Provide specific recommendations for improvements.
```

Usage:
```bash
/my-command
```

## Using Commands with System Prompts

You can combine slash commands with system prompts for more specialized reviews:

```bash
# This is handled by the command definition
/review-pr

# For more control, use the CLI directly
claude --system-prompt-file ./prompts/code-review.txt "Review this PR with focus on database changes"
```

## Tips

1. **Keep commands focused**: Each command should have a clear, specific purpose
2. **Use descriptive names**: Command names should indicate what they do
3. **Add context**: Include relevant context in the command prompt
4. **Be specific**: Specific instructions lead to better results
5. **Test commands**: Try commands on different types of changes

## Command vs System Prompt

**Slash Commands** (`.claude/commands/*.md`):
- Quick, predefined tasks
- Invoked with `/command-name`
- Great for common workflows
- Easy to share with team

**System Prompts** (`prompts/*.txt`):
- More detailed, comprehensive instructions
- Used with `--system-prompt-file` flag
- Better for complex, nuanced reviews
- More flexible for different scenarios

## Integration with Workflows

### In Git Hooks

```bash
#!/bin/bash
# .git/hooks/pre-push

claude /security-check
```

### In Makefiles

```makefile
review:
	@echo "Running PR review..."
	@claude /review-pr

security:
	@echo "Running security check..."
	@claude /security-check
```

### In Scripts

```bash
#!/bin/bash
# review.sh

case "$1" in
  pr)
    claude /review-pr
    ;;
  security)
    claude /security-check
    ;;
  docs)
    claude /doc-quality
    ;;
  perf)
    claude /perf-check
    ;;
  *)
    echo "Usage: $0 {pr|security|docs|perf}"
    exit 1
    ;;
esac
```

## See Also

- `prompts/README.md` - Custom system prompts documentation
- `.claude/hooks/` - Session hooks configuration
- `.github/workflows/` - GitHub Actions workflows

## Learn More

- [Claude Code Slash Commands](https://docs.claude.com/claude-code/slash-commands)
- [Creating Custom Commands](https://docs.claude.com/claude-code/custom-commands)
