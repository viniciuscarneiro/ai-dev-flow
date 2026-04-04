# AI Dev Flow - Project Memory

## What is this project

AI Dev Flow is a methodology kit for AI-assisted software development. It provides 10 slash commands that guide AI coding assistants through a structured SDLC (9-step feature lifecycle plus `/flow-seed` for onboarding and `/flow-debug` parallel). It supports GitHub Copilot, Cursor, Claude Code, OpenAI Codex, and Google Antigravity with shared prompts.

Repo: https://github.com/viniciuscarneiro/ai-dev-flow
License: MIT
Owner: viniciuscarneiro

## The Flow (10 commands, 9 sequential feature steps + parallel)

```
/flow-seed     Import existing docs into knowledge/ (onboarding, parallel)
/flow-prd      Product Requirements + DoD (Amazon Working Backwards, MoSCoW)
/flow-ux       UX/UI Design Specification (Atomic Design, Design Tokens, Motion, WCAG 2.2)
/flow-rfc      Request for Comments (System Design Dimensions, Decision Matrix)
/flow-ta       Tech Assessment (28 engineering categories, BDD)
/flow-code     Implementation (TDD Beck, Clean Code, Full-cycle)
/flow-review   Code Review (11 dimensions, OWASP 2025, Google/Microsoft guidelines)
/flow-doc      Documentation (Living Documentation, C4, ADR Nygard)
/flow-done     Feature Completion (Google PRR, Amazon ORR, Microsoft Ship/No-Ship)
/flow-debug    Debug (parallel, Agans 9 Rules, Fishbone, Post-Mortem)
```

## Project structure

```
./                                  Root (distribution repo)
├── README.md                       EN readme (marketing tech tone)
├── README.pt-br.md                 PT-BR readme
├── LICENSE                         MIT
├── CLAUDE.md                       Maintainer project memory (versioned in this repo)
├── setup.sh                        Installer (71 files, idempotent, never overwrites)
├── .gitignore                      Ignores .claude/settings.local.json
│
├── .agent/workflows/               Cursor wrappers (10 files)
├── .agent/skills/                  Antigravity wrappers (10 files)
├── .agents/skills/                 Codex wrappers (10 files)
├── .claude/commands/               Claude Code wrappers (10 files)
├── .github/prompts/                Copilot wrappers (10 files)
├── .github/CODEOWNERS              @viniciuscarneiro reviews everything
│
└── ai-dev-flow/
    ├── PLAYBOOK.md                 Operating manual (the full reference)
    ├── prompts/                    Source of truth (10 prompts)
    │   ├── flow-seed.md
    │   ├── flow-prd.md
    │   ├── flow-ux.md
    │   ├── flow-rfc.md
    │   ├── flow-ta.md
    │   ├── flow-code.md
    │   ├── flow-review.md
    │   ├── flow-doc.md
    │   ├── flow-done.md
    │   └── flow-debug.md
    ├── knowledge/                  Permanent knowledge base
    │   ├── guidelines/
    │   │   ├── engineering-principles.md   Shared reference (SOLID, Clean Code, DDD, etc)
    │   │   ├── design-principles.md        Shared reference (Atomic Design, Tokens, Motion, A11y)
    │   │   └── _template.md
    │   ├── adrs/_template.md               Nygard format
    │   ├── architecture/_template.md       C4 Model with Mermaid
    │   ├── prds/_template.md               PRD format
    │   └── assessments/_template.md        TA format
    └── work/                       Volatile artifacts
        ├── specs/                  Active PRDs, RFCs, TAs, Done reports
        └── drafts/
            └── analysis/           Debug reports
```

## Key design decisions

- `CLAUDE.md` at the repo root is **tracked**: shared context for maintainers of this kit. It is **not** installed by `setup.sh` into consumer projects (they use `PLAYBOOK.md` and `knowledge/`). Contributors may add a local `CLAUDE.md` in their own apps; this file documents **this** repository.
- Prompts are in English, tech-agnostic
- Wrappers (.github/, .agent/, .claude/) just point to ai-dev-flow/prompts/ (single source of truth)
- _template.md files are ignored by prompts, they exist as format guides for users
- work/ is volatile, knowledge/ is permanent. Promotion requires user approval.
- engineering-principles.md is shared between flow-ta, flow-code, flow-review, flow-doc, flow-debug
- design-principles.md is shared by flow-ux and referenced by flow-code and flow-review for UI work
- DoD is defined in PRD, refined after TA, validated in review, and formally checked in flow-done
- flow-debug is parallel (step 9), can be triggered anytime
- Each prompt has: Flow Position, Role, Context, Input, Process, Output, Rules, Instruction

## Repo settings

- Branch protection: PR required, linear history (squash only), conversation resolution required
- Enforce admins: on
- Approval required: 0 (solo contributor mode, increase when team grows)
- Secret scanning + push protection: enabled
- Merge strategy: squash only, delete branch on merge
- CODEOWNERS: @viniciuscarneiro for everything

## Writing style preferences (owner)

- No em dashes. Never use the character: —
- No co-author lines in commits
- Write naturally, avoid AI-sounding patterns
- Portuguese for conversation, English for code and docs
- Prefer direct, concise language

## References used in prompts

- PRD: Amazon Working Backwards, MoSCoW prioritization
- RFC: Google Design Docs, Uber RFCs, System Design Dimensions
- TA: 28 engineering categories, BDD Gherkin, SOLID, Clean Architecture, DDD, GoF
- Code: TDD (Kent Beck Canon 2023), SMURF (Google 2024), Clean Code (Martin), Fowler Two Hats
- Review: Google Code Review Guidelines, Microsoft Engineering Fundamentals, OWASP Top 10:2025
- Doc: Living Documentation (Martraire), C4 Model (Brown), ADR (Nygard), Docs as Code
- Done: Google SRE PRR, Amazon ORR, Microsoft Ship/No-Ship, Wix Feature Retros, Scrum DoD
- UX: Double Diamond, Design Thinking (IDEO), Atomic Design (Brad Frost), Material Design 3, Apple HIG, WCAG 2.2, Awwwards, Godly
- Debug: Agans 9 Rules, Google SRE Incident Management, Amazon COE, Fishbone/Ishikawa

## What was discussed but not implemented yet

- GUIDE.md (practical step-by-step tutorial, deleted for now, may revisit)
- npx ai-dev-flow init (CLI installer, evolve from setup.sh if project gains traction)
- Signed commits requirement (optional, can enable later)
- CODEOWNERS review requirement (enable when more contributors join)
- Selling strategy: MIT core forever, monetize via Pro/Enterprise tooling around it (Open Core model)
