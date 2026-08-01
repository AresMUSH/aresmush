---
toc: Community
summary: Register and manage your alt tracker (email + code word).
aliases:
- alttracker
- alts
- register/alt
- register/update
- register/status
- register/word
- register/wordcheck
- register/ban
- register/unban
- register/banhistory
---

# Alt Tracker / Register

The Alt Tracker system links your characters to a single player email address protected by a secret **code word**. This lets staff verify ownership when you need a password reset and prevents unauthorized people from claiming your characters.

**Keep your code word private.** Staff will never ask you for it in public.

## Player Commands

### register &lt;email&gt;=&lt;code word&gt;

Initial registration. Creates a new alt tracker (or links you to an existing one if the email + code word already match).

```
register me@example.com=swordfish
```

You can only do this once per character. If you are already registered, the command will fail.

### register/alt &lt;character&gt;=&lt;code word&gt;

Link this character to the same tracker as another character you already control. You must supply the correct code word for that tracker.

```
register/alt Bob=swordfish
```

### register/update &lt;string&gt;=&lt;code word&gt;

Change either your email address or your code word. The current code word is required.

- If `&lt;string&gt;` looks like a valid email, it updates the email.
- Otherwise it is treated as a new code word.

```
register/update new@email.com=swordfish
register/update myNewCodeWord=swordfish
```

### register/status

Shows your current tracker information: the email on file, whether the tracker is banned, and the list of characters linked to it.

Staff may also view another character’s status:

```
register/status
register/status Bob
```

## Staff Commands

These commands require the **admin** or **staff** role.

### register/word &lt;character&gt;=&lt;new code word&gt;

Resets the code word on a character’s tracker. After using this, send the new code word to the email address on file.

```
register/word Bob=newSwordfish
```

### register/wordcheck &lt;character&gt;

Displays the current code word for a character’s tracker. Used when a guest claims to have lost a password — ask them for the code word first.

```
register/wordcheck Bob
```

### register/ban &lt;character&gt;[=&lt;days&gt;]

Bans the alt tracker associated with the character. No new characters can be registered to that email while banned.

- No duration → permanent ban
- With a number of days → temporary ban

```
register/ban Bob
register/ban Bob=7
```

### register/unban &lt;character&gt;

Removes a ban from the character’s alt tracker.

```
register/unban Bob
```

### register/banhistory &lt;character&gt;

Shows the full ban/unban history for the tracker (who, when, duration).

```
register/banhistory Bob
```

## Security Notes

- Knowing the code word **or** having access to the email on file is required to make changes.
- Staff can always view or reset the code word because they can contact the email on file.
- A banned tracker blocks new registrations and most player-side changes.
- Temporary bans automatically expire; permanent bans stay until staff unban them.
