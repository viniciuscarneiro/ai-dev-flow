## Contributing to AI Dev Flow

Thanks for helping improve AI Dev Flow.

### Ground rules

- Keep prompts in `ai-dev-flow/prompts/` as the single source of truth.
- Keep wrappers in sync with prompts. Wrappers should only reference prompt files.
- Prefer small, focused pull requests.
- Preserve backwards compatibility for existing users whenever possible.
- Do not add breaking process changes without documenting migration guidance.

### When you change prompts or flow behavior

Update these together in the **same pull request** whenever behavior, wording, or install output changes:

- `ai-dev-flow/prompts/`
- `ai-dev-flow/PLAYBOOK.md`
- `README.md` and `README.pt-br.md` (for user-facing flow and counts)
- All wrapper trees: `.github/prompts/`, `.agent/workflows/`, `.agent/skills/`, `.claude/commands/`, `.agents/skills/`
- `setup.sh` if install steps, file count, or printed next-steps change (keep `EXPECTED_FILE_COUNT` in `setup.sh` aligned with what a clean install creates; CI reads it)

### Command matrix (source of truth for ordering)

| Command | Step | Role (short) | Default next step |
|---------|------|--------------|-------------------|
| `/flow-seed` | Onboarding (parallel) | Import existing docs into `knowledge/` | `/flow-prd` when ready to define work |
| `/flow-prd` | 1 | Product requirements and DoD | `/flow-ux` if there is a user-facing UI; otherwise `/flow-rfc` |
| `/flow-ux` | 2 | UX and UI specification | `/flow-rfc` |
| `/flow-rfc` | 3 | Technical options and recommendation | `/flow-ta` |
| `/flow-ta` | 4 | Engineering design, BDD, plan | `/flow-code` |
| `/flow-code` | 5 | Implementation | `/flow-review` |
| `/flow-review` | 6 | Multi-dimensional review and DoD check | `/flow-doc` if passing |
| `/flow-doc` | 7 | ADRs, architecture, living docs | `/flow-done` when ready to ship |
| `/flow-done` | 8 | Production readiness and go or no-go | Ship or return to `/flow-code` |
| `/flow-debug` | Parallel | Systematic investigation | `/flow-code` when a fix is needed |

Parallel means `/flow-debug` and `/flow-seed` can run outside the numbered sequence. Use `/flow-seed` when `knowledge/` is thin (often before the first `/flow-prd`). Skipping `/flow-ux` for backend-only work is documented in `ai-dev-flow/PLAYBOOK.md` and `ai-dev-flow/prompts/flow-ux.md`.

### Continuous integration

Pull requests and pushes to `main` run GitHub Actions (see `.github/workflows/ci.yml`):

- **Markdown link check** using [lychee](https://github.com/lycheeverse/lychee) on `*.md` files, **excluding** `ai-dev-flow/prompts/` (reference URLs there often block automated clients). `.lycheeignore` lists URLs that are valid for humans but return **403** to CI (for example Claude and OpenAI product homepages linked from the README badges). Add patterns there if a new badge or link starts failing only in automation.
- **setup.sh smoke test** installs into an empty directory, reads **`EXPECTED_FILE_COUNT`** from `setup.sh`, asserts that many files, core paths, and `ai-dev-flow/work/drafts/analysis/`.

If you change what `setup.sh` creates, bump **`EXPECTED_FILE_COUNT`**, update the README file count in both languages, and adjust CI expectations in the same PR.

### Development workflow

1. Fork the repository.
2. Create a feature branch from `main`.
3. Make focused changes and update documentation when needed.
4. Open a pull request. For docs or methodology changes, prefer the **Documentation and methodology** template when GitHub offers it.

### Quality checklist (all PRs)

Before opening a PR:

- [ ] Problem and solution are clear in the PR description.
- [ ] CI would pass: links valid, `setup.sh` smoke assumptions still true.
- [ ] No unrelated formatting churn.

### Documentation and methodology PRs (extra)

Use this when you touch README, PLAYBOOK, prompts, wrappers, `setup.sh`, `CONTRIBUTING.md`, or CI.

- [ ] English and Portuguese READMEs stay aligned for user-visible flow and install claims.
- [ ] No-UI path (`PRD` to `RFC`) stays consistent across diagrams, prompts, and PLAYBOOK.
- [ ] Command naming matches the matrix above (`Validate it` for `/flow-review`, not mixed with `Review it`).
- [ ] `work/drafts/analysis/` is still reflected wherever `work/` is described.
- [ ] **`EXPECTED_FILE_COUNT`** in `setup.sh` matches a clean install (`find` on a fresh target) and both READMEs.

### Pull request templates

- Default: `.github/pull_request_template.md`
- Documentation focused: `.github/PULL_REQUEST_TEMPLATE/documentation.md`

### Maintainer writing style

- Prefer no em dash in commit messages and other maintainer notes.
- Files under `ai-dev-flow/prompts/` may use normal English punctuation, including em dash, for readability. Do not rewrite prompts only to remove em dashes.

### Code of conduct

Be respectful, collaborative, and constructive in reviews and discussions.
