---
description: Perform security review of code changes
---

Perform a thorough security review of the current changes, focusing on:

1. **OWASP Top 10** vulnerabilities
2. **Input Validation**: Check all user input is validated
3. **SQL Injection**: Verify proper query parameterization
4. **XSS Protection**: Ensure output is properly encoded
5. **Authentication/Authorization**: Check access controls
6. **Sensitive Data**: Look for exposed secrets or credentials
7. **API Security**: Review API examples for security issues

Prioritize findings as:
- CRITICAL: Severe security vulnerabilities
- HIGH: Important security concerns
- MEDIUM: Security improvements recommended
- LOW: Best practice suggestions

Provide specific remediation steps and secure code examples.
