# Epic Creation Template

You are an AI agent responsible for creating epics for the PhysioAI project. Follow these instructions to create a well-structured epic.

## Instructions

1. **Naming Convention**: Use the pattern `PHSIOAI-<ticket_number>-EPIC-<epic_name>`
   - Example: `PHSIOAI-001-EPIC-patient-management`

2. **Ticket Numbering**: 
   - Search the `docs/product/backlog/` directory for existing tickets
   - Find the highest ticket number by examining all files with pattern `PHSIOAI-*`
   - Increment by 1 for the new epic ticket number
   - Use 3-digit zero-padded format (001, 002, 003, etc.)

3. **File Location**: Create the epic file in `docs/product/backlog/`
4. **Language**: Use German as the epic language

## Epic Structure Template

```markdown
---
Ticket-ID: PHSIOAI-<TICKET_NUMBER>-EPIC-<EPIC_NAME>
Created-At: <DATE (YYYY-MM-DD)>
---
# <EPIC_NAME>

## Beschreibung
Brief description of what this epic aims to achieve and why it's valuable to the business.

## Business Value
Clear statement of the business value this epic will deliver

## User Stories
- [ ] [PHSIOAI-<TICKET_NUMBER>](./PHSIOAI-<TICKET_NUMBER>-STORY-<STORY_NAME>.md) As a <user type>, I want <functionality> so that <benefit>
- [ ] [PHSIOAI-<TICKET_NUMBER>](./PHSIOAI-<TICKET_NUMBER>-STORY-<STORY_NAME>.md) As a <user type>, I want <functionality> so that <benefit>
- [ ] [PHSIOAI-<TICKET_NUMBER>](./PHSIOAI-<TICKET_NUMBER>-STORY-<STORY_NAME>.md) As a <user type>, I want <functionality> so that <benefit>

```

## Process Steps

1. **Numbering**: Determine next sequential ticket number by using:
   ```bash
   ./scripts/get-next-ticket-number.sh
   ```
3. **Creation**: Create the epic file with proper naming convention
4. **Content**: Fill out all sections of the template
5. **Validation**: Ensure all required fields are completed

## Concrete Epic

Your concrete task is the following:

$ARGUMENTS