#!/usr/bin/env bash
# S1 review tool: inspect the checked-out PR head and post a pull review
# whose body carries the machine-readable finding set. Findings are real
# results of static checks on the diff content.
set -euo pipefail

findings=$(python3 - <<'PY'
import ast, json, pathlib, sys

items = []
path = pathlib.Path("sample.py")
if not path.exists():
    items.append({
        "source_key": "s1-review.sample-missing",
        "severity": "high",
        "position": "sample.py",
        "summary": "sample.py is absent from the change head",
    })
else:
    tree = ast.parse(path.read_text())
    fn = next((n for n in ast.walk(tree) if isinstance(n, ast.FunctionDef) and n.name == "greet"), None)
    if fn is None:
        items.append({
            "source_key": "s1-review.greet-missing",
            "severity": "high",
            "position": "sample.py",
            "summary": "greet() is not defined in sample.py",
        })
    else:
        if ast.get_docstring(fn) is None:
            items.append({
                "source_key": "s1-review.missing-docstring",
                "severity": "medium",
                "position": "sample.py:greet",
                "summary": "greet() has no docstring; public helpers must document contract",
            })
        guarded = False
        for node in ast.walk(fn):
            if isinstance(node, ast.Constant) and node.value is None:
                guarded = True
        if not guarded:
            items.append({
                "source_key": "s1-review.unguarded-none",
                "severity": "medium",
                "position": "sample.py:greet",
                "summary": "greet() does not handle None input explicitly; callers may pass None",
            })
print(json.dumps(items))
PY
)

body=$(python3 - "$findings" <<'PY'
import json, sys
items = json.loads(sys.argv[1])
lines = ["S1 automated review."]
if items:
    lines.append("Findings:")
    for it in items:
        lines.append(f"- [{it['severity']}] {it['position']}: {it['summary']}")
else:
    lines.append("No findings.")
lines.append("")
lines.append("```s1-findings")
lines.append(json.dumps(items, indent=2))
lines.append("```")
print("\n".join(lines))
PY
)

gh api "repos/${GITHUB_REPOSITORY}/pulls/${PR_NUMBER}/reviews" \
  -f event=COMMENT -f commit_id="${HEAD_SHA}" -f body="${body}" \
  --jq '{id: .id, commit: .commit_id, state: .state}'
