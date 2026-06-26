# Contributing to Roblox Game Studios

Thank you for your interest in contributing to Roblox Game Studios! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

---

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [INSERT CONTACT METHOD].

---

## How Can I Contribute?

### 🐛 Reporting Bugs

Before creating bug reports, please check the issue list as you might find that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include screenshots if possible**

### 💡 Suggesting Features

Feature suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the steps**
- **Describe the current behavior and explain the behavior you expected**
- **Explain why this enhancement would be useful**

### 🔧 Pull Requests

- Fill in the required template
- Do not include issue numbers in the PR title
- Include screenshots and animated GIFs in your pull request whenever possible
- Follow the Roblox Luau style guide
- Include thoughtfully-worded, well-structured tests
- Document new code
- End all files with a newline

---

## Development Setup

### Prerequisites

- Roblox Studio (latest version)
- Git
- Text editor (VS Code recommended with Luau extension)

### Setup Steps

1. **Fork the repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/roblox-game-studios.git
   cd roblox-game-studios
   ```

3. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Edit files in `skills/`, `templates/`, or `scripts/`
   - Test your changes in Roblox Studio

5. **Test your changes**
   - Validate templates are complete and well-formatted
   - Test skills with real Roblox projects
   - Ensure scripts work correctly

6. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add your descriptive commit message"
   ```

7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**
   - Go to the original repository
   - Click "New Pull Request"
   - Select your branch
   - Fill in the PR template

---

## Pull Request Process

1. **Update documentation** — If you change behavior, update the relevant documentation
2. **Update examples** — If you add features, add examples showing usage
3. **Test thoroughly** — Ensure your changes work in real Roblox projects
4. **Follow style guidelines** — Use consistent formatting and naming
5. **Write clear commit messages** — Explain what and why, not how
6. **Request review** — Ask for review from maintainers

### PR Template

```markdown
## Description

[Describe your changes]

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing

- [ ] I have tested these changes in Roblox Studio
- [ ] I have tested the templates with real projects
- [ ] I have verified scripts work correctly

## Checklist

- [ ] My code follows the style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
```

---

## Style Guidelines

### Markdown Templates

- Use consistent heading levels (H1 for title, H2 for sections, H3 for subsections)
- Include table of contents for long documents
- Use code blocks with language specifiers
- Include examples and use cases
- Keep line length under 100 characters when possible

### Luau Code Examples

```lua
-- ✅ Good: Clear naming, proper structure
local PlayerManager = {}
PlayerManager.__index = PlayerManager

function PlayerManager.new(player)
    local self = setmetatable({}, PlayerManager)
    self.player = player
    self.data = nil
    return self
end

-- ❌ Bad: Unclear naming, poor structure
local pm = {}
function pm:init(p)
    self.p = p
    self.d = nil
end
```

### Documentation Style

- Use active voice
- Be concise and clear
- Include code examples
- Explain "why" not just "what"
- Use consistent terminology

### Commit Messages

```
feat: Add new balance check for economy system
fix: Correct DataStore retry logic
docs: Update GDD template with Roblox section
style: Format code examples consistently
refactor: Simplify skill structure
test: Add unit tests for score calculation
chore: Update dependencies
```

---

## Community

### Getting Help

- **GitHub Issues** — For bugs and feature requests
- **GitHub Discussions** — For questions and general discussion
- **Roblox DevForum** — For Roblox-specific questions

### Recognition

Contributors will be recognized in:
- README.md contributors section
- CHANGELOG.md for their contributions
- GitHub releases for significant contributions

### Code of Conduct

We are committed to providing a welcoming and inspiring community for all. Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before participating.

---

## Questions?

If you have questions about contributing, please:
1. Check the [documentation](docs/)
2. Search [existing issues](https://github.com/YOUR_USERNAME/roblox-game-studios/issues)
3. Create a [new discussion](https://github.com/YOUR_USERNAME/roblox-game-studios/discussions)

Thank you for contributing to Roblox Game Studios! 🎮
