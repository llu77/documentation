# Custom System Prompts for Claude Code

This directory contains custom system prompts for use with Claude Code CLI. System prompts provide specialized context and instructions for different types of code and documentation review.

## Available System Prompts

### 1. code-review.txt
**Purpose:** Comprehensive code and documentation review

**Focus Areas:**
- Documentation quality and clarity
- Code quality and best practices
- Technical accuracy
- Structure and organization
- Completeness
- Security and best practices

**Best for:** General PR reviews, code reviews, documentation reviews

### 2. security-review.txt
**Purpose:** Security-focused code review

**Focus Areas:**
- Authentication and authorization
- Input validation
- Output encoding
- Data protection
- Database security
- API security
- OWASP Top 10 vulnerabilities

**Best for:** Security audits, reviewing sensitive code, API reviews

### 3. documentation-quality.txt
**Purpose:** Technical writing and documentation review

**Focus Areas:**
- Clarity and readability
- Structure and organization
- Technical accuracy
- Code examples
- Visual elements
- RST formatting
- Completeness and consistency

**Best for:** Documentation updates, technical writing review, RST formatting

### 4. performance-review.txt
**Purpose:** Performance optimization review

**Focus Areas:**
- Algorithm efficiency
- Database performance
- Memory usage
- Caching strategies
- I/O operations
- Code optimization

**Best for:** Performance-critical code, scalability reviews, optimization

### 5. accessibility-review.txt
**Purpose:** Accessibility (a11y) compliance review

**Focus Areas:**
- WCAG 2.1 compliance
- Text and content accessibility
- Keyboard navigation
- Screen reader support
- Visual design
- Forms and inputs
- Multimedia accessibility

**Best for:** UI/UX reviews, accessibility audits, inclusive design

## Usage

### Using with Claude Code CLI

#### Basic Usage

```bash
# Review with custom system prompt
claude --system-prompt-file ./prompts/code-review.txt "Review this PR"

# Security review
claude --system-prompt-file ./prompts/security-review.txt "Check for security issues"

# Documentation quality review
claude --system-prompt-file ./prompts/documentation-quality.txt "Review the documentation"
```

#### With Additional Arguments

```bash
# Combine with other CLI options
claude --system-prompt-file ./prompts/code-review.txt \
       --max-turns 10 \
       --model claude-sonnet-4-5-20250929 \
       "Review this PR for issues"

# Use in plan mode
claude -p --system-prompt-file ./prompts/security-review.txt \
       "Audit this code for vulnerabilities"
```

#### In GitHub Actions

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Review this PR"
    claude_args: |
      --system-prompt-file ./prompts/code-review.txt
      --max-turns 10
```

### Using with Slash Commands

This project includes convenient slash commands that incorporate the system prompts:

```bash
# In Claude Code CLI
/review-pr          # Comprehensive PR review
/security-check     # Security-focused review
/doc-quality        # Documentation quality review
/perf-check         # Performance review
```

These commands are defined in `.claude/commands/` and automatically use appropriate review strategies.

## Creating Custom Prompts

### Template Structure

```
[Role Definition]
You are a [expert type] specializing in [area].

## Review Focus Areas

### 1. [Category Name]
- [Specific check]
- [Specific check]

### 2. [Category Name]
- [Specific check]

## Review Guidelines

- [Guideline 1]
- [Guideline 2]

## Output Format

**[SECTION NAME]:**
- [What to include]
```

### Example Custom Prompt

Create `prompts/my-custom-review.txt`:

```
You are an expert in [your domain]. Review code for:

## Focus Areas

### 1. [Area 1]
- Check for [specific item]
- Verify [specific item]

### 2. [Area 2]
- Look for [specific item]

## Output Format

**CRITICAL:**
- List critical issues

**RECOMMENDATIONS:**
- List recommendations
```

### Best Practices for Custom Prompts

1. **Be Specific**: Clearly define what to look for
2. **Organize**: Use clear sections and categories
3. **Prioritize**: Help Claude prioritize findings
4. **Provide Structure**: Define expected output format
5. **Include Context**: Add domain-specific knowledge
6. **Set Scope**: Define what's in/out of scope
7. **Give Examples**: Include example outputs if helpful

## Combining Prompts

You can combine multiple review perspectives:

```bash
# Run multiple reviews in sequence
claude --system-prompt-file ./prompts/code-review.txt "Review this PR" && \
claude --system-prompt-file ./prompts/security-review.txt "Check security"

# Or use a comprehensive prompt
claude "Review this PR for code quality, security, and performance"
```

## Tips for Effective Reviews

### 1. Choose the Right Prompt
- **General changes**: Use `code-review.txt`
- **Security-sensitive**: Use `security-review.txt`
- **Documentation**: Use `documentation-quality.txt`
- **Performance-critical**: Use `performance-review.txt`
- **User-facing**: Use `accessibility-review.txt`

### 2. Provide Context
```bash
claude --system-prompt-file ./prompts/code-review.txt \
       "Review the changes in content/applications/finance/ focusing on the new payment examples"
```

### 3. Use Specific Requests
```bash
# Instead of: "Review this"
# Use: "Review this PR focusing on the database migration scripts for security issues"
```

### 4. Combine with Git
```bash
# Review specific commits
git diff main...feature-branch | claude --system-prompt-file ./prompts/code-review.txt "Review these changes"

# Review specific files
claude --system-prompt-file ./prompts/security-review.txt "Review content/applications/finance/payment.rst for security issues in code examples"
```

## Integration Examples

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running code review..."
claude --system-prompt-file ./prompts/code-review.txt \
       "Review staged changes" || exit 1
```

### CI/CD Pipeline

```yaml
# .github/workflows/code-review.yml
- name: Review with Custom Prompt
  run: |
    claude --system-prompt-file ./prompts/code-review.txt \
           --max-turns 5 \
           "Review the changes in this PR"
```

### NPM/Make Scripts

```makefile
# Makefile
review:
	@claude --system-prompt-file ./prompts/code-review.txt "Review current changes"

security-audit:
	@claude --system-prompt-file ./prompts/security-review.txt "Audit for security issues"

doc-check:
	@claude --system-prompt-file ./prompts/documentation-quality.txt "Check documentation quality"
```

## Prompt Maintenance

### Version Control
- Keep prompts in version control
- Document changes to prompts
- Consider prompt versioning for major changes

### Testing Prompts
```bash
# Test a new prompt
claude --system-prompt-file ./prompts/new-prompt.txt "Test review"

# Compare prompt effectiveness
claude --system-prompt-file ./prompts/version1.txt "Review X" > review1.txt
claude --system-prompt-file ./prompts/version2.txt "Review X" > review2.txt
diff review1.txt review2.txt
```

### Iterating on Prompts
1. Start with a basic prompt
2. Run reviews and note gaps
3. Refine the prompt based on results
4. Test with different types of code
5. Gather feedback from team
6. Update and version

## Advanced Usage

### Environment Variables

```bash
# Set default prompt
export CLAUDE_SYSTEM_PROMPT_FILE="./prompts/code-review.txt"

# Use in scripts
claude "Review this PR"  # Uses default prompt
```

### Conditional Prompts in Scripts

```bash
#!/bin/bash
# review.sh

if [[ "$1" == "security" ]]; then
  PROMPT_FILE="./prompts/security-review.txt"
elif [[ "$1" == "docs" ]]; then
  PROMPT_FILE="./prompts/documentation-quality.txt"
else
  PROMPT_FILE="./prompts/code-review.txt"
fi

claude --system-prompt-file "$PROMPT_FILE" "${@:2}"
```

Usage:
```bash
./review.sh security "Check API endpoints"
./review.sh docs "Review new tutorial"
./review.sh "General review"
```

## Troubleshooting

### Prompt Not Found
```bash
# Use absolute path
claude --system-prompt-file /absolute/path/to/prompts/code-review.txt "Review"

# Or ensure you're in the right directory
cd /path/to/documentation
claude --system-prompt-file ./prompts/code-review.txt "Review"
```

### Prompt Too Long
- System prompts are limited in size
- Keep prompts focused and concise
- Split into multiple specialized prompts if needed

### Inconsistent Results
- Make prompts more specific
- Add examples of expected output
- Define clear success criteria
- Use structured output formats

## Resources

- [Claude Code Documentation](https://docs.claude.com/claude-code)
- [System Prompts Guide](https://docs.anthropic.com/claude/docs/system-prompts)
- [Prompt Engineering Guide](https://docs.anthropic.com/claude/docs/prompt-engineering)

## Contributing

To add a new system prompt:

1. Create a new `.txt` file in this directory
2. Follow the template structure
3. Add documentation to this README
4. Test with various code examples
5. Submit a PR with examples of usage

## License

These prompts are part of the Odoo documentation project and follow the same license.
