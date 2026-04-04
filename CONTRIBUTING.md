## Contributing to AI Dev Flow

Thanks for helping improve AI Dev Flow.

### Ground Rules

- Keep prompts in `ai-dev-flow/prompts/` as the single source of truth.
- Keep wrappers in sync with prompts. Wrappers should only reference prompt files.
- Prefer small, focused pull requests.
- Preserve backwards compatibility for existing users whenever possible.
- Do not add breaking process changes without documenting migration guidance.

### Development Workflow

1. Fork the repository.
2. Create a feature branch from `main`.
3. Make focused changes and update documentation when needed.
4. Open a pull request with:
   - problem statement
   - proposed change
   - validation done

### What to Update Together

When changing flow behavior, update these locations together:

- `ai-dev-flow/prompts/`
- `ai-dev-flow/PLAYBOOK.md`
- `README.md`
- `README.pt-br.md`
- `setup.sh` (if setup output text is affected)

### Quality Checklist

Before opening a PR:

- [ ] Content is consistent across EN and PT-BR docs when applicable.
- [ ] Links are valid.
- [ ] Flow order and command names are consistent everywhere.
- [ ] "Never overwrite existing files" behavior in `setup.sh` is preserved.
- [ ] No unrelated formatting churn.

### Code of Conduct

Be respectful, collaborative, and constructive in reviews and discussions.
