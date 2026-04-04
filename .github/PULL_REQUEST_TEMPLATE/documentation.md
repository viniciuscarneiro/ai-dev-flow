---
name: Documentation and methodology
about: Changes to README, PLAYBOOK, prompts, wrappers, or contributor docs
---

## Summary

## Scope

- [ ] `README.md` / `README.pt-br.md`
- [ ] `ai-dev-flow/PLAYBOOK.md`
- [ ] `ai-dev-flow/prompts/*.md`
- [ ] Wrapper files under `.github/`, `.agent/`, `.agents/`, `.claude/`
- [ ] `setup.sh` output or install behavior
- [ ] `CONTRIBUTING.md` or CI

## Methodology impact

- [ ] No change to the intended flow order
- [ ] Flow order or default next-step behavior changed (describe below)

If behavior changed, describe the new rule (for example no-UI path, debug artifacts, or promotion rules):

## Parity and consistency

- [ ] English and Portuguese READMEs updated together when the change is user-facing
- [ ] Command names and step wording match `CONTRIBUTING.md` command matrix
- [ ] `setup.sh` still never overwrites existing files
- [ ] File count in READMEs matches `setup.sh` (currently 71 files on a clean install)

## Links and references

- [ ] No broken internal links to removed paths
- [ ] External links still appropriate (CI will check Markdown links)

## Reviewer hints

Optional context, screenshots of rendered Markdown, or related issues.
