#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

VERSION="$(tr -d '[:space:]' < VERSION)"
echo "Syncing distributions for META-SCAFFOLD v$VERSION..."

# 1. Sync .claude-plugin/plugin.json version
python3 - "$VERSION" <<'PY'
import json
import sys

version = sys.argv[1]
with open(".claude-plugin/plugin.json", "r", encoding="utf-8") as f:
    plugin = json.load(f)

plugin["version"] = version

with open(".claude-plugin/plugin.json", "w", encoding="utf-8") as f:
    json.dump(plugin, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
echo "  [✓] .claude-plugin/plugin.json"

# 2. Sync skills/index.json files list
python3 - <<'PY'
import json
import os

skill_root = "skills/meta-scaffold"
files = []
for root, _, filenames in os.walk(skill_root):
    for fn in filenames:
        rel = os.path.relpath(os.path.join(root, fn), skill_root)
        files.append(rel)

files.sort()

index_data = {
    "skills": [
        {
            "name": "meta-scaffold",
            "files": files
        }
    ]
}

with open("skills/index.json", "w", encoding="utf-8") as f:
    json.dump(index_data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
echo "  [✓] skills/index.json"

# 3. Sync Cursor distribution rule
cp .cursor/rules/meta-scaffold.mdc dist/CURSOR.mdc
echo "  [✓] dist/CURSOR.mdc"

echo "Sync completed successfully."
