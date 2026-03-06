---
name: brainstorming
description: Use before any creative work — features, components, behavior changes — to design before implementing
---
# Brainstorming

## When

You are about to create something, add a feature, or change behavior. Turn the idea into an approved design before writing code. Every project goes through this — "too simple to design" is always wrong.

<HARD-GATE>
Do NOT write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. No exceptions.
</HARD-GATE>

## Iron Laws

1. No implementation until design is presented and user approves.
2. Ask clarifying questions one at a time; prefer multiple choice.
3. Propose 2-3 approaches with trade-offs and a recommendation.
4. Present design section by section; get approval after each.
5. Terminal state: invoke the planning skill. No other skill follows brainstorming.

## Process

1. **Explore context.** Check files, docs, recent commits.
2. **Ask questions.** One per message. Focus on purpose, constraints, success criteria.
3. **Propose approaches.** 2-3 options with trade-offs. Lead with your recommendation.
4. **Present design.** Section by section, scaled to complexity. Cover architecture, data flow, error handling, testing.
5. **Get approval.** After each section, ask if it looks right. Revise as needed.
6. **Apply YAGNI.** Remove anything not requested.
7. **Write design doc.** Save to `docs/plans/YYYY-MM-DD-<topic>-design.md`, commit.
8. **Invoke planning.** Transition to the planning skill for task decomposition.

## Checklist

- [ ] Project context explored
- [ ] Clarifying questions answered
- [ ] 2-3 approaches proposed
- [ ] Design approved section by section
- [ ] Design doc committed
- [ ] Planning skill invoked

## Composability

Input: user idea or feature request. Output: approved design doc ready for planning.
