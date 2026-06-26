# Changelog

All notable changes to Roblox Game Studios will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-06-26

### 🎉 Initial Release

**Roblox Game Studios** — Professional game development framework for Roblox!

### ✨ Added

#### Core Skills
- **`/roblox-gdd`** — Create structured Game Design Documents with Roblox-specific sections
- **`/roblox-adr`** — Record Architecture Decision Records with Roblox compatibility analysis
- **`/roblox-economy`** — Design economy models with formulas, faucets, sinks, and balance targets
- **`/roblox-design-review`** — Review design documents for completeness, consistency, and feasibility
- **`/roblox-code-review`** — Review code quality with Roblox-specific checks (server/client, DataStore, RemoteEvent)
- **`/roblox-balance-check`** — Validate game balance for economy, combat, progression, loot, and field systems

#### Templates
- **GDD Template** (220 lines) — Complete game design document with player fantasy, detailed rules, formulas, edge cases, tuning knobs, game feel, and Roblox implementation notes
- **ADR Template** (176 lines) — Architecture decision record with problem statement, constraints, decision, alternatives, consequences, and Roblox-specific considerations
- **Economy Template** (183 lines) — Economy model with currencies, sources, sinks, balance targets, progression curves, loot tables, and ethical guardrails
- **Test Plan Template** (280 lines) — Comprehensive test plan with unit, integration, multiplayer, boundary, performance, and security tests

#### Scripts
- **validate-gdd.sh** — Bash script to validate GDD completeness and check for missing sections

#### References
- **quick-reference.md** — Command cheat sheet with workflow examples

#### Documentation
- **README.md** — Comprehensive documentation with English and Chinese versions
- **CONTRIBUTING.md** — Contribution guidelines with development setup and PR process
- **LICENSE** — MIT License for open-source distribution

### 🎯 Roblox-Specific Features

#### Server/Client Architecture
- Checks for proper separation (server calculates, client displays)
- Validates RemoteEvent protocols and anti-cheat measures
- Warns against server modifying visual properties (syncs to all clients)

#### DataStore Safety
- Validates retry mechanisms and error handling
- Checks for Session Lock implementation
- Warns about data size limits (4MB per request)

#### Performance Budgets
- Part count monitoring (target ≤1700)
- FPS monitoring (target ≥60)
- Memory allocation checks
- Hot path optimization validation

#### Data-Driven Design
- Validates all values read from GameConfig.lua
- Warns against hardcoded magic numbers
- Checks formula completeness with variable tables

### 📚 Inspired By

- **Claude Code Game Studios** by [Donchitos](https://github.com/Donchitos) — Foundational concepts for structured AI-assisted game development
- **Roblox Developer Community** — Best practices for Roblox development
- **Professional Game Development** — MDA Framework, Flow Theory, Architecture Decision Records

---

## [Unreleased]

### 🔮 Planned Features

- **More Templates**
  - Sound Design Document
  - Art Bible Template
  - Narrative Design Document
  - Live Ops Plan

- **More Skills**
  - `/roblox-sound-review` — Review sound design
  - `/roblox-art-review` — Review art assets
  - `/roblox-narrative-review` — Review narrative design
  - `/roblox-live-ops` — Plan live operations

- **Integration Features**
  - Roblox Studio plugin for in-editor templates
  - GitHub Actions for automated validation
  - CLI tool for template generation

- **Community Features**
  - Template marketplace
  - Best practices wiki
  - Example projects gallery

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2026-06-26 | Initial release with core skills, templates, and documentation |
| Unreleased | - | Planned features and improvements |

---

## How to Update

### From GitHub

```bash
# Pull latest changes
git pull origin main

# Copy updated files
cp -r skills/* /path/to/your/skills/directory/
```

### Manual Update

1. Download the latest release from GitHub
2. Replace old files with new ones
3. Review CHANGELOG.md for breaking changes

---

## Breaking Changes

None yet! This is the initial release.

---

## Deprecations

None yet! This is the initial release.

---

## Contributors

Thank you to all contributors who have helped make Roblox Game Studios better!

- [Cgei] — Creator and maintainer
- [Contributors will be added here]

---

## Acknowledgments

Special thanks to:

- [Donchitos](https://github.com/Donchitos) for [Claude Code Game Studios](https://github.com/Donchitos/Claude-Code-Game-Studios)
- Roblox Developer Community for best practices and feedback
- All early adopters and testers

---

## Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/roblox-game-studios/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/roblox-game-studios/discussions)
- **Documentation**: [docs/](docs/)

---

**Thank you for using Roblox Game Studios!** 🎮
