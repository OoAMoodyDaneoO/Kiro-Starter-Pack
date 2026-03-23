#!/bin/bash
# validate.sh — Structural validation for the Kiro Starter Kit repository.
# Checks that all required directories, files, section headings, and inline
# comments are present. Prints a pass/fail summary at the end.
#
# Usage:
#   chmod +x validate.sh
#   ./validate.sh

set -euo pipefail

# ---------------------------------------------------------------------------
# Counters
# ---------------------------------------------------------------------------
PASS=0
FAIL=0

pass() {
  echo "  ✅ PASS: $1"
  PASS=$((PASS + 1))
}

fail() {
  echo "  ❌ FAIL: $1"
  FAIL=$((FAIL + 1))
}

# ---------------------------------------------------------------------------
# Helper: check that a file exists
# ---------------------------------------------------------------------------
check_file() {
  local file="$1"
  local label="${2:-$file}"
  if [ -f "$file" ]; then
    pass "$label exists"
  else
    fail "$label is missing"
  fi
}

# ---------------------------------------------------------------------------
# Helper: check that a directory exists
# ---------------------------------------------------------------------------
check_dir() {
  local dir="$1"
  local label="${2:-$dir}"
  if [ -d "$dir" ]; then
    pass "$label directory exists"
  else
    fail "$label directory is missing"
  fi
}

# ---------------------------------------------------------------------------
# Helper: count .md files in a directory (excludes .gitkeep)
# ---------------------------------------------------------------------------
count_md_files() {
  local dir="$1"
  find "$dir" -maxdepth 1 -name '*.md' -type f | wc -l | tr -d ' '
}

# ---------------------------------------------------------------------------
# Helper: check that a file contains a string (case-insensitive)
# ---------------------------------------------------------------------------
check_content() {
  local file="$1"
  local pattern="$2"
  local label="$3"
  if grep -qi "$pattern" "$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
}

# ---------------------------------------------------------------------------
# Helper: check that a file contains an HTML comment (<!-- ... -->)
# ---------------------------------------------------------------------------
check_inline_comments() {
  local file="$1"
  local label
  label="$(basename "$file") contains inline comments"
  if grep -q '<!--' "$file" 2>/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
}

echo "========================================"
echo " Kiro Starter Kit — Validation"
echo "========================================"
echo ""

# ===================================================================
# 1. Root-level files  (Req 1.7, 1.8, 1.9)
# ===================================================================
echo "--- Root-level files ---"
check_file "README.md"
check_file "LICENSE"
check_file ".gitignore"
echo ""

# ===================================================================
# 2. Directory structure  (Req 1.1–1.6)
# ===================================================================
echo "--- Directory structure ---"
check_dir ".kiro/steering"  "steering"
check_dir ".kiro/hooks"     "hooks"
check_dir ".kiro/powers"    "powers"
check_dir ".kiro/agents"    "agents"
check_dir ".kiro/skills"    "skills"
check_file ".kiro/mcp.json" "mcp.json"
echo ""

# ===================================================================
# 3. File counts  (Req 1.1–1.6)
# ===================================================================
echo "--- File counts ---"

steering_count=$(count_md_files ".kiro/steering")
if [ "$steering_count" -ge 6 ]; then
  pass "Steering files: $steering_count (expected >= 6)"
else
  fail "Steering files: $steering_count (expected >= 6)"
fi

hooks_count=$(count_md_files ".kiro/hooks")
if [ "$hooks_count" -ge 6 ]; then
  pass "Hook files: $hooks_count (expected >= 6)"
else
  fail "Hook files: $hooks_count (expected >= 6)"
fi

agents_count=$(find ".kiro/agents" -maxdepth 1 -name '*.md' -type f ! -name 'README.md' | wc -l | tr -d ' ')
if [ "$agents_count" -ge 8 ]; then
  pass "Agent files: $agents_count (expected >= 8)"
else
  fail "Agent files: $agents_count (expected >= 8)"
fi

skills_count=$(find ".kiro/skills" -name 'SKILL.md' -type f | wc -l | tr -d ' ')
if [ "$skills_count" -ge 10 ]; then
  pass "Skill files: $skills_count (expected >= 10)"
else
  fail "Skill files: $skills_count (expected >= 10)"
fi
echo ""

# ===================================================================
# 4. mcp.json validation  (Req 1.5, 11.1–11.6)
# ===================================================================
echo "--- MCP configuration ---"

# Try python3 first, fall back to node for JSON parsing
if command -v python3 &>/dev/null; then
  json_check=$(python3 -c "
import json, sys
try:
    data = json.load(open('.kiro/mcp.json'))
    servers = data.get('mcpServers', {})
    count = len(servers)
    print(count)
except Exception as e:
    print('INVALID')
" 2>&1)
elif command -v node &>/dev/null; then
  json_check=$(node -e "
try {
  const data = JSON.parse(require('fs').readFileSync('.kiro/mcp.json', 'utf8'));
  const count = Object.keys(data.mcpServers || {}).length;
  console.log(count);
} catch(e) { console.log('INVALID'); }
" 2>&1)
else
  json_check="SKIP"
fi

if [ "$json_check" = "INVALID" ]; then
  fail "mcp.json is not valid JSON"
elif [ "$json_check" = "SKIP" ]; then
  fail "mcp.json validation skipped (no python3 or node available)"
else
  pass "mcp.json is valid JSON"
  if [ "$json_check" -ge 3 ] && [ "$json_check" -le 4 ]; then
    pass "mcp.json has $json_check server entries (expected 3–4)"
  else
    fail "mcp.json has $json_check server entries (expected 3–4)"
  fi
fi
echo ""

# ===================================================================
# 5. README content checks  (Req 13.1–13.5)
# ===================================================================
echo "--- README sections ---"
check_content "README.md" "## Table of Contents"       "README has Table of Contents"
check_content "README.md" "## Quick Start"              "README has Quick Start section"
check_content "README.md" "### Steering Files"          "README has Steering Files section"
check_content "README.md" "### Hooks"                   "README has Hooks section"
check_content "README.md" "### Powers"                  "README has Powers section"
check_content "README.md" "### Sub-Agents"              "README has Sub-Agents section"
check_content "README.md" "### MCP Servers"             "README has MCP Servers section"
check_content "README.md" "### Skills"                  "README has Skills section"
check_content "README.md" "## Customization"            "README has Customization section"
check_content "README.md" "## Contributing"             "README has Contributing section"
echo ""

# ===================================================================
# 6. Steering file section headings  (Req 2.1–2.4, 3.1–3.5, 4.1–4.5,
#    5.1–5.5, 6.1–6.4, 7.1–7.4)
# ===================================================================
echo "--- Steering file content ---"

# coding-standards.md (Req 2.1–2.4)
cs=".kiro/steering/coding-standards.md"
check_content "$cs" "### Naming Conventions"       "coding-standards: Naming Conventions"
check_content "$cs" "### Code Formatting"          "coding-standards: Code Formatting"
check_content "$cs" "### Documentation"            "coding-standards: Documentation Expectations"
check_content "$cs" "### Error Handling"            "coding-standards: Error Handling Patterns"

# testing-standards.md (Req 3.1–3.5)
ts=".kiro/steering/testing-standards.md"
check_content "$ts" "### Test File Organization"    "testing-standards: Test File Organization"
check_content "$ts" "### Test Naming"               "testing-standards: Test Naming Conventions"
check_content "$ts" "### Test Structure"            "testing-standards: Test Structure"
check_content "$ts" "### Mocking"                   "testing-standards: Mocking and Stubbing"
check_content "$ts" "### Property-Based Testing"    "testing-standards: Property-Based Testing"

# aws-best-practices.md (Req 4.1–4.5)
aws=".kiro/steering/aws-best-practices.md"
check_content "$aws" "### IAM Polic"               "aws-best-practices: IAM Policies"
check_content "$aws" "### Resource Tagging"         "aws-best-practices: Resource Tagging"
check_content "$aws" "### Encryption"               "aws-best-practices: Encryption"
check_content "$aws" "### Logging"                  "aws-best-practices: Logging and Monitoring"
check_content "$aws" "### Infrastructure"           "aws-best-practices: Infrastructure-as-Code"

# security-standards.md (Req 5.1–5.5)
sec=".kiro/steering/security-standards.md"
check_content "$sec" "### Input Validation"         "security-standards: Input Validation"
check_content "$sec" "### Secret Management"        "security-standards: Secret Management"
check_content "$sec" "### Dependency Management"    "security-standards: Dependency Management"
check_content "$sec" "### Authentication"           "security-standards: Authentication and Authorization"
check_content "$sec" "### Output Encoding"          "security-standards: Output Encoding"

# code-review-standards.md (Req 6.1–6.4)
cr=".kiro/steering/code-review-standards.md"
check_content "$cr" "### Review Scope"              "code-review-standards: Review Scope"
check_content "$cr" "### Feedback Tone"             "code-review-standards: Feedback Tone"
check_content "$cr" "### Review Checklists"         "code-review-standards: Review Checklists"
check_content "$cr" "### Approval Criteria"         "code-review-standards: Approval Criteria"

# documentation-standards.md (Req 7.1–7.4)
ds=".kiro/steering/documentation-standards.md"
check_content "$ds" "### README Structure"          "documentation-standards: README Structure"
check_content "$ds" "### API Documentation"         "documentation-standards: API Documentation"
check_content "$ds" "### Inline Comments"           "documentation-standards: Inline Comments"
check_content "$ds" "### Changelog"                 "documentation-standards: Changelog Maintenance"
echo ""

# ===================================================================
# 7. Hook inline comments  (Req 8.7)
# ===================================================================
echo "--- Hook inline comments ---"
for f in .kiro/hooks/*.md; do
  [ -f "$f" ] && check_inline_comments "$f"
done
echo ""

# ===================================================================
# 8. Powers  (Req 9.5)
# ===================================================================
echo "--- Powers ---"
check_file ".kiro/powers/README.md" "Powers README"
echo ""

# ===================================================================
# 9. Agent configuration checks  (Req 10.9)
# ===================================================================
echo "--- Agent configuration checks ---"
for f in .kiro/agents/*.md; do
  [ -f "$f" ] || continue
  [[ "$(basename "$f")" == "README.md" ]] && continue
  label="$(basename "$f") has YAML frontmatter"
  if head -1 "$f" | grep -q '^---' 2>/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
done
echo ""

# ===================================================================
# 10. Skill configuration checks  (Req 12.11)
# ===================================================================
echo "--- Skill configuration checks ---"
for f in .kiro/skills/*/SKILL.md; do
  [ -f "$f" ] || continue
  label="$(basename "$(dirname "$f")")/SKILL.md has YAML frontmatter"
  if head -1 "$f" | grep -q '^---' 2>/dev/null; then
    pass "$label"
  else
    fail "$label"
  fi
done
echo ""

# ===================================================================
# Summary
# ===================================================================
TOTAL=$((PASS + FAIL))
echo "========================================"
echo " Results: $PASS passed, $FAIL failed (out of $TOTAL checks)"
echo "========================================"

if [ "$FAIL" -eq 0 ]; then
  echo " 🎉 All checks passed!"
  exit 0
else
  echo " ⚠️  Some checks failed. Review the output above."
  exit 1
fi
