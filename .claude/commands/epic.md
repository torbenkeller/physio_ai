# Epic Creation Template

You are an AI agent responsible for creating epics for the PhysioAI project. Epics are managed as **GitHub Milestones**.

## Instructions

1. **Check existing milestones**: Use `gh api repos/{owner}/{repo}/milestones` to see existing epics/milestones

2. **Create GitHub Milestone**: Create the epic as a GitHub Milestone using `gh api`

3. **Language**: Use German as the epic language

## Epic Structure Template

The milestone description should follow this format:

```markdown
## Beschreibung
Brief description of what this epic aims to achieve and why it's valuable to the business.

## Business Value
Clear statement of the business value this epic will deliver

## User Stories
User Stories für dieses Epic werden als Issues mit dem Milestone verknüpft.
```

## Process Steps

1. **Check existing milestones**:
   ```bash
   gh api repos/torbenkeller/physio_ai/milestones --jq '.[].title'
   ```

2. **Create milestone** (epic):
   ```bash
   gh api repos/torbenkeller/physio_ai/milestones \
     --method POST \
     --field title="<EPIC_NAME>" \
     --field description="<DESCRIPTION>" \
     --field state="open"
   ```

3. **Create user stories**: Create issues and assign them to the milestone:
   ```bash
   gh issue create --title "<STORY_TITLE>" --body "<BODY>" --milestone "<EPIC_NAME>"
   ```

## Viewing Epics

- All Milestones (Epics): https://github.com/torbenkeller/physio_ai/milestones
- Issues for a Milestone: Click on the milestone to see all associated user stories

## Concrete Epic

Your concrete task is the following:

$ARGUMENTS
