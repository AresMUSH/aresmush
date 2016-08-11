Ares has an event-driven architecture.   

**Requests** come from the client to the server, and represent player commands or requests for information.   A Request always gets a **Response**.  Responses may also come independently from the server back to the client after certain game events.

# Requests

**Requests** come from the client to the server, and represent player commands or requests for information.  

## Command

A client has issued a command to the game.  This is used for new-school clients that interact directly through the API.

event-type: "command"
command: command name
id: random guid to identify the event
token: authorization token (see Authorization, above)
data:  hash of command-specific arguments

Example of a command setting a description:

    {
        event-type: "command",
        command: "set desc",
        id: "e8f3827c-ccc4-4ad0-b25c-7b233ff140f9",
        token: "73fdb8b5-3ea3-489e-ba22-7774b3e9de59",
        data: 
        {
            target: "me",
            desc: "This is my desc."
        }
    }

Refer to the individual plugin documentation for available commands.

## Input

This event represents typed input directly from a user.  This is for old-school clients that do everything via the command line.  Input will be translated into commands.

event-type: "input"
input:  what the user typed
id: random guid to identify the event
token: authorization token (see Authorization, above)

Example of setting a description using input instead of a command.  The server would internally translate this into a command such as the one above:

    {
        event-type: "input",
        id: "8fb2f3f7-77b4-4e97-a614-989321f9f3df",
        token: "73fdb8b5-3ea3-489e-ba22-7774b3e9de59",
        input: "desc me=This is my desc."
    }

# Responses

**Responses** convey information from the server back to the client.  Every Request gets a Response, and Responses can also come independently after certain game events.

## Command Output

This is sent back to the client after a command.  If the command asked the server to do something (like set a description), the response will tell you if it succeeded or failed.   If the command was requesting information (like getting the who list), the response will contain that information.

event-type: "output"
id: random guid to identify the event
command-id:  Refers back to the id of the command that this is in response to
token:  authorization token (see Authorization, above)
status: ok or error to indicate if the command succeeded or failed
data: hash of response-specific data
mush-output: response formatted for display in old MUSH clients.  New clients can choose to use this or format the data their own way.

Example of a response after setting the description:

    {
        event-type: "output",
        id: "c91614be-5b30-4a2b-809e-0e400066a569",
        command-id: "e8f3827c-ccc4-4ad0-b25c-7b233ff140f9",  // Same as the original command
        token: "73fdb8b5-3ea3-489e-ba22-7774b3e9de59",
        status: "ok"
        mush-output: "You set the description."
    }

Example of a response after asking for the who list (the exact fields provided will vary based on the game configuration):

    {
        event-type: "output",
        id: "58f00346-f2f8-47dc-b9f7-416e0a5f270b",
        command-id: "e8f3827c-ccc4-4ad0-b25c-7b233ff140f9",  // Same as the original command
        token: "73fdb8b5-3ea3-489e-ba22-7774b3e9de59",
        status: "ok"
        mush-output: "Big blob of formatted who list data",
        data:
        {
            header:
                game-title:  "My MUSH"
            players:
                [
                    { name: "Joe", faction: "Red", idle: "2s", handle: "@Star" },
                    { name: "Bob", faction: "Blue", idle: "2s", handle: "" }
                ]
            footer:
                total-ic: 12
                total-online: 16
                record-online: 22
        }
    }

Refer to the individual plugin documentation for details about response data.

## Notification

A notification is a special kind of response that comes independently of a command.  This is typically used for game events that can happen at any time, like a new mail message coming in, or a player connecting. 

event-type: "notification",
id: random guid to identify the event
token:  authorization token (see Authorization, above)
notification-type: what the notification is about
mush-output: response formatted for display in old MUSH clients.  New clients can choose to use this or format the data their own way.
data: hash of response-specific data

    {
        event-type: "notification",
        id: "bbb55e77-cecc-4d3c-8ca1-daad2dedbbd6",
        token: "73fdb8b5-3ea3-489e-ba22-7774b3e9de59",
        notification-type: "chat activity"
        mush-output: "<Chat> Faraday says, \"Hi!\"",
        data:
            channel: "Chat"
            message: "Faraday says, \"Hi!\""
    }

Refer to the individual plugin documentation for details about response data.