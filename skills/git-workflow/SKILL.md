---
name: git-workflow
description: Use when starting isolated feature work or finishing a development branch
---
# Git Workflow

## When
Starting feature work needing a clean workspace (worktrees). Or finishing development -- merging, opening a PR, keeping a branch, or discarding work.

## Iron Laws
1. Run baseline tests in the worktree before making changes.
2. Verify worktree directory is gitignored before creating project-local worktrees.
3. Never force-push or delete branches without explicit user approval.
4. Tests must pass before offering completion options.
5. Clean up worktrees after merge or discard. Keep only when the branch is kept.

## Process
1. **Starting:** Check for .worktrees/ or worktrees/. Check CLAUDE.md for preference. If neither, ask.
2. Verify directory is gitignored. If not, add to .gitignore and commit.
3. Create worktree: `git worktree add <path> -b <branch>`. Run project setup.
4. Run tests. Report baseline. If failing, report and ask before proceeding.
5. Do the work. Commit as you go.
6. **Finishing:** Run tests. If failing, fix before proceeding.
7. Present 4 options: (1) merge locally, (2) push and create PR, (3) keep as-is, (4) discard.
8. Merge: checkout base, pull, merge, test merged result, delete branch, remove worktree.
9. PR: push with `-u`, create PR with summary, keep worktree until merged.
10. Discard: show what will be deleted, require typed "discard" confirmation, then clean up.

## Composability
Input: task requiring isolated development. Output: work integrated into target branch (or cleanly discarded), worktree cleaned up.
