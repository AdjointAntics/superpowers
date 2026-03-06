---
name: using-superpowers
description: Always loaded — invoke skills before any response
---
# Using Superpowers

## When

Every conversation. Before any response — including clarifying questions — check if a skill applies.

<EXTREMELY-IMPORTANT>
If there is even a 1% chance a skill applies, you MUST invoke it. Not negotiable. Not optional.
</EXTREMELY-IMPORTANT>

## Iron Laws

1. Invoke skills BEFORE any response, including clarifying questions.
2. Process skills first (brainstorming, debugging), then implementation skills.
3. Rigid skills (TDD, debugging): follow exactly. Flexible: adapt.
4. User instructions say WHAT not HOW — never skip workflows.

## Process

1. Receive message. Skill might apply, even 1%? Invoke now.
2. Announce: "Using [skill] to [purpose]."
3. Checklist in skill? Create a todo per item.
4. Follow the skill. Respond only after obligations met.

## Red Flags

| Thought | Reality |
|---------|---------|
| "Simple question" | Questions are tasks. Check. |
| "Need context first" | Skills BEFORE clarifying. |
| "Let me explore" | Skills say HOW. |
| "I remember it" | Skills evolve. Read current. |
| "Overkill" | Simple becomes complex. |

## Composability

Input: any user message. Output: correct skill(s) invoked before work begins.
