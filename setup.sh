#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# AI Dev Flow — Setup Script
# Copies the AI Dev Flow structure into your project.
# Safe: never overwrites existing files.
# ─────────────────────────────────────────────

VERSION="3.0.1"
# Single source of truth for README, CONTRIBUTING, and CI (setup-smoke). Bump when the install set changes.
EXPECTED_FILE_COUNT=71

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  cat <<EOF
AI Dev Flow — setup.sh

Usage:
  ./setup.sh /path/to/your/application/project
  ./setup.sh .                    # install into the current directory (must be your app repo root)

Options:
  -h, --help    Show this help

What it does:
  Copies prompts, knowledge templates, playbook, and assistant wrappers into the target.
  Never overwrites existing files (safe to re-run).

Expected first-time install: ${EXPECTED_FILE_COUNT} new files. If the target already contains
ai-dev-flow/, files are skipped. Point the script at your application repository, not at a
clone of the ai-dev-flow methodology repo unless you mean to merge kits.

Repository: https://github.com/viniciuscarneiro/ai-dev-flow
EOF
  exit 0
fi

TARGET="${1:-.}"
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"

# Colors (disable if not a terminal)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  RED='\033[0;31m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  GREEN='' YELLOW='' RED='' CYAN='' BOLD='' NC=''
fi

created=0
skipped=0
skipped_files=()

echo ""
echo -e "${BOLD}AI Dev Flow${NC} — Setup v${VERSION}"
echo "────────────────────────────────────"
echo ""

# Validate target
if [ ! -d "$TARGET" ]; then
  echo -e "${RED}Error:${NC} Target directory does not exist: $TARGET"
  echo "Usage: ./setup.sh /path/to/your/project"
  exit 1
fi

echo -e "Source: ${CYAN}${SCRIPT_DIR}${NC}"
echo -e "Target: ${BOLD}${TARGET}${NC}"
echo ""

if [ -f "$TARGET/ai-dev-flow/PLAYBOOK.md" ]; then
  echo -e "${YELLOW}Note:${NC} This directory already contains ${BOLD}ai-dev-flow/${NC}."
  echo -e "      Existing files are never overwritten, so re-runs may skip everything."
  echo -e "      To install into a different app, pass that repo path: ${BOLD}./setup.sh /path/to/your-app${NC}"
  echo ""
fi

# ─── Helper: copy file safely ───────────────
copy_file() {
  local src="$1"
  local dest="$2"

  if [ -f "$dest" ]; then
    skipped=$((skipped + 1))
    skipped_files+=("$dest")
    echo -e "  ${YELLOW}! Skipped${NC}  $(echo "$dest" | sed "s|$TARGET/||")"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    created=$((created + 1))
    echo -e "  ${GREEN}+ Created${NC}  $(echo "$dest" | sed "s|$TARGET/||")"
  fi
}

# ─── Helper: create dir with .gitkeep ───────
ensure_dir() {
  local dir="$1"
  mkdir -p "$TARGET/$dir"
  if [ ! -f "$TARGET/$dir/.gitkeep" ]; then
    touch "$TARGET/$dir/.gitkeep"
    echo -e "  ${GREEN}+ Created${NC}  $dir/.gitkeep"
    created=$((created + 1))
  fi
}

# ─── 1. Copy ai-dev-flow/ core ───
echo -e "${BOLD}[1/4] ai-dev-flow/ core${NC}"

# Playbook
copy_file "$SCRIPT_DIR/ai-dev-flow/PLAYBOOK.md" "$TARGET/ai-dev-flow/PLAYBOOK.md"

# Prompts (source of truth)
for f in "$SCRIPT_DIR"/ai-dev-flow/prompts/flow-*.md; do
  name="$(basename "$f")"
  copy_file "$f" "$TARGET/ai-dev-flow/prompts/$name"
done

# Shared references (engineering + design principles)
copy_file "$SCRIPT_DIR/ai-dev-flow/knowledge/guidelines/engineering-principles.md" \
          "$TARGET/ai-dev-flow/knowledge/guidelines/engineering-principles.md"
copy_file "$SCRIPT_DIR/ai-dev-flow/knowledge/guidelines/design-principles.md" \
          "$TARGET/ai-dev-flow/knowledge/guidelines/design-principles.md"

echo ""

# ─── 2. Copy knowledge/ templates ───
echo -e "${BOLD}[2/4] knowledge/ templates${NC}"

for dir in guidelines adrs architecture prds assessments; do
  template="$SCRIPT_DIR/ai-dev-flow/knowledge/$dir/_template.md"
  if [ -f "$template" ]; then
    copy_file "$template" "$TARGET/ai-dev-flow/knowledge/$dir/_template.md"
  fi
done

echo ""

# ─── 3. Create work/ directories ───
echo -e "${BOLD}[3/4] work/ directories${NC}"

ensure_dir "ai-dev-flow/work/specs"
ensure_dir "ai-dev-flow/work/drafts"
ensure_dir "ai-dev-flow/work/drafts/analysis"

echo ""

# ─── 4. Copy AI coding assistant wrappers ───
echo -e "${BOLD}[4/4] AI coding assistant wrappers${NC}"

echo "  GitHub Copilot:"
for f in "$SCRIPT_DIR"/.github/prompts/*.prompt.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  copy_file "$f" "$TARGET/.github/prompts/$name"
done

echo "  Cursor:"
for f in "$SCRIPT_DIR"/.agent/workflows/*.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  copy_file "$f" "$TARGET/.agent/workflows/$name"
done

echo "  Claude Code:"
for f in "$SCRIPT_DIR"/.claude/commands/*.md; do
  [ -f "$f" ] || continue
  name="$(basename "$f")"
  copy_file "$f" "$TARGET/.claude/commands/$name"
done

echo "  Codex CLI:"
for d in "$SCRIPT_DIR"/.agents/skills/*/; do
  [ -d "$d" ] || continue
  skill="$(basename "$d")"
  copy_file "$d/SKILL.md" "$TARGET/.agents/skills/$skill/SKILL.md"
done

echo "  Antigravity:"
for d in "$SCRIPT_DIR"/.agent/skills/*/; do
  [ -d "$d" ] || continue
  skill="$(basename "$d")"
  copy_file "$d/SKILL.md" "$TARGET/.agent/skills/$skill/SKILL.md"
done

echo ""

# ─── Summary ───
echo "────────────────────────────────────"
echo -e "${BOLD}Done!${NC} ${GREEN}${created} files created${NC}, ${YELLOW}${skipped} skipped${NC}."
echo ""

if [ "$skipped" -eq 0 ] && [ "$created" -ne "$EXPECTED_FILE_COUNT" ]; then
  echo -e "${RED}Error:${NC} First-time install should create exactly ${EXPECTED_FILE_COUNT} files, got ${created}."
  echo -e "      The methodology package in ${CYAN}${SCRIPT_DIR}${NC} may be incomplete or out of sync."
  exit 1
fi

if [ ${#skipped_files[@]} -gt 0 ]; then
  echo -e "${YELLOW}Skipped files (already exist):${NC}"
  for sf in "${skipped_files[@]}"; do
    echo "  - $(echo "$sf" | sed "s|$TARGET/||")"
  done
  echo ""
fi

# ─── Next Steps ───
echo -e "${BOLD}Next steps:${NC}"
echo ""
echo -e "  1. ${BOLD}Seed your knowledge base${NC} (recommended before the first /flow-prd):"
echo -e "     Run ${BOLD}/flow-seed${NC} with your AI assistant to import existing docs safely (never overwrites by default),"
echo -e "     or copy manually into ai-dev-flow/knowledge/:"
echo -e "       - Guidelines     → ai-dev-flow/knowledge/guidelines/"
echo -e "       - ADRs           → ai-dev-flow/knowledge/adrs/"
echo -e "       - Architecture   → ai-dev-flow/knowledge/architecture/"
echo -e "       - PRDs           → ai-dev-flow/knowledge/prds/"
echo -e "       - Tech Assessments → ai-dev-flow/knowledge/assessments/"
echo -e "     Each folder has a _template.md showing the expected format."
echo ""
echo -e "  2. ${BOLD}Read the playbook${NC}:"
echo -e "     ai-dev-flow/PLAYBOOK.md"
echo ""
echo -e "  3. ${BOLD}Start using the flow${NC}:"
echo -e "     /flow-seed   → Import docs into knowledge/ (onboarding, optional)"
echo -e "     /flow-prd    → Define what to build"
echo -e "     /flow-ux     → Design the experience"
echo -e "     /flow-rfc    → Choose how to build it"
echo -e "     /flow-ta     → Design the details"
echo -e "     /flow-code   → Build it"
echo -e "     /flow-review → Validate it"
echo -e "     /flow-doc    → Document it"
echo -e "     /flow-done   → Ship it"
echo -e "     /flow-debug  → Debug (anytime)"
echo ""
