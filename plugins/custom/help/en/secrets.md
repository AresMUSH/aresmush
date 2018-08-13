---
toc: Character Creation
summary: Setting secret preferences and viewing secrets.
---
# Secrets
Secrets are admin-created pieces of information about your character, which your character may or may not be aware of. They are hooks for plots and story development over time. 

You can set your secret preferences to let admin know whether you're interested in secrets. 

`secret/preference = <preference>` - Set your secret preference.
Preferences are: 
- None - No secrets at all
- Known - You know the secret about your character
- GM - Only GMs know the secret about your character until it comes out in play.

`secrets` - View known secrets. 

## Admin Commands
`secrets <name>` - View <name>'s known and GM secrets.
`secrets/set <name>=<secret>` - Set a secret on a character.
`gmsecrets <name>` - View <name>'s GM-only secrets
`gmsecrets/set <name>=<secret>` - Set a GM only secret on a character.