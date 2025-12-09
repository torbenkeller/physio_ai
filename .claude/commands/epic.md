# Epic Creation Template

You are an AI agent responsible for creating epics for the PhysioAI project. Follow these instructions to create a well-structured epic.

## Instructions

1. **Naming Convention**: Use the pattern `PHSIOAI-<ticket_number>-EPIC-<epic_name>`
   - Example: `PHSIOAI-001-EPIC-patient-management`

2. **Ticket Numbering**:
   - Use `gh issue list` to check existing issues
   - Find the highest ticket number by examining all issues
   - Use the GitHub Issue number as ticket number

3. **Create GitHub Issue**: Create the epic as a GitHub Issue with label `epic`

4. **Language**: Use German as the epic language

## Epic Structure Template

```markdown
# <EPIC_NAME>

## Beschreibung
Brief description of what this epic aims to achieve and why it's valuable to the business.

## Business Value
Clear statement of the business value this epic will deliver

## User Stories
- [ ] #<ISSUE_NUMBER> Als <persona> möchte ich <funktionalität>, damit <benefit>
- [ ] #<ISSUE_NUMBER> Als <persona> möchte ich <funktionalität>, damit <benefit>
- [ ] #<ISSUE_NUMBER> Als <persona> möchte ich <funktionalität>, damit <benefit>

```

## Process Steps

1. **Check existing issues**: Use `gh issue list --label epic` to see existing epics
2. **Create epic issue**: Use `gh issue create --label epic --title "<EPIC_NAME>" --body "<BODY>"`
3. **Content**: Fill out all sections of the template
4. **Link user stories**: Reference user story issues using #<number>

## Concrete Epic

Your concrete task is the following:

$ARGUMENTS
