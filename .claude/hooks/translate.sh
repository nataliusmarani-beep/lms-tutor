#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Bilingual Translation Agent — PostToolUse hook
# Fires after every Edit/Write tool call.
# Scans the modified file for new UI strings and keeps
# src/lib/i18n.ts in sync with English + Bahasa Indonesia.
# ─────────────────────────────────────────────────────────────

INPUT=$(cat)

# ── 1. Extract the file path from the hook JSON payload ──────
FILE_PATH=$(echo "$INPUT" | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    # Works for both Edit (file_path) and Write (file_path)
    fp = d.get('tool_input', {}).get('file_path', '')
    print(fp)
except Exception:
    print('')
" 2>/dev/null || echo "")

# ── 2. Guard: only process TypeScript/TSX UI files ───────────
[[ -z "$FILE_PATH" ]]           && exit 0   # no path
[[ "$FILE_PATH" != *.tsx ]] \
  && [[ "$FILE_PATH" != *.ts ]] && exit 0   # not TS/TSX
[[ "$FILE_PATH" == *"i18n.ts"* ]] && exit 0  # skip the dict itself
[[ "$FILE_PATH" == *".d.ts" ]]    && exit 0  # skip declaration files
[[ "$FILE_PATH" == *"node_modules"* ]] && exit 0

PROJECT="/Users/nataliusfillepmarani/Documents/LMS-Tutor"
I18N="$PROJECT/src/lib/i18n.ts"

# ── 3. Spin up the translation sub-agent in the background ───
claude -p "
You are the bilingual translation agent for the LMS-Tutor project
(a tutoring platform used in Indonesia with English/Bahasa toggle).

A source file was just modified:
  $FILE_PATH

Your task — do all four steps silently:

STEP 1 — Read the modified file: $FILE_PATH
STEP 2 — Read the translation dictionary: $I18N
STEP 3 — Identify gaps:
  a) Any hardcoded English UI strings in the file that are rendered
     to the user but NOT yet covered by a key in i18n.ts.
  b) Any t(lang, \"someKey\") call whose key is missing from i18n.ts.
STEP 4 — If gaps exist, add them to BOTH the 'en' AND 'id' sections
  of $I18N using the Edit tool.

Strict rules:
• Use camelCase keys consistent with the existing convention.
• Indonesian must sound natural for a K-12 / tutoring context
  (formal but friendly — not stiff machine translation).
• NEVER remove or alter existing translations.
• NEVER add keys that are already present (check carefully).
• If there is nothing new to add, make NO changes and output nothing.
• Do not explain your work — just make the edits (or nothing).
" --allowedTools "Read,Edit" --output-format text 2>/dev/null &

exit 0
