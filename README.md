discorddotlua is a modern, object‑oriented Discord API library for the Luvit runtime environment. It brings the structure and developer experience of libraries like discord.js  and discord.py  into the Lua ecosystem. The library supports slash commands, interactions, caching, intents, presence, moderation tools, and a full suite of Discord object wrappers.

discorddotlua is designed to be lightweight, fast, and easy to understand while still offering the features expected from a contemporary Discord SDK.

Features
Gateway v10 support

Slash commands (global and guild)

Interactions API (commands, buttons, menus, modals)

REST API wrapper

Intents and presence updates

Caching for guilds, channels, users, and members

Moderation utilities including bans, kicks, and timeouts

Object‑oriented design with a complete set of Discord objects

Built for the Luvit runtime (LuaJIT + libuv)

Installation
discorddotlua is distributed through the lit package manager.

Once published, install it with:

Code
lit install Cake/discorddotlua
Then require it in your project:

lua
local discorddotlua = require("discorddotlua")
Quick Start
Create a file named bot.lua:

lua
local discorddotlua = require("discorddotlua")

local client = discorddotlua.Client:new("Bot YOUR_TOKEN", {
    presence = {
        status = "online",
        activities = { { name = "using discorddotlua", type = 0 } }
    }
})

client:on("READY", function(data)
    print("Logged in as " .. data.user.username)
end)

client:on("MESSAGE_CREATE", function(message)
    if message.content == "!ping" then
        message:reply("Pong!")
    end
end)

client:run()
Run your bot with:

Code
luvit bot.lua
Slash Commands
Register a command
lua
client:registerGlobalCommand(APP_ID, {
    name = "ping",
    description = "Replies with Pong"
})
Handle interactions
lua
client:on("INTERACTION_CREATE", function(interaction)
    if interaction.data.name == "ping" then
        interaction:reply("Pong from discorddotlua")
    end
end)
Moderation
Kick a member
lua
member:kick("Reason for kick")
Ban a member
lua
member:ban("Reason for ban", 1) -- delete 1 day of messages
Timeout a member
lua
member:timeout("2025-12-31T23:59:59Z", "Reason for timeout")
Object Model
discorddotlua includes object wrappers for the following:

Message

Channel

User

Guild

Member

Role

Interaction

Embed

Attachment

Emoji

Thread

Webhook

Sticker

VoiceState

Invite

These objects wrap Discord’s raw JSON into structured, easy‑to‑use classes.

Intents
discorddotlua enables a set of default intents:

GUILDS

GUILD_MESSAGES

MESSAGE_CONTENT

You can override them:

lua
local client = discorddotlua.Client:new("Bot TOKEN", {
    intents = bit.bor(
        1 << 0,   -- GUILDS
        1 << 1,   -- GUILD_MEMBERS
        1 << 9    -- GUILD_MESSAGES
    )
})
Embeds
lua
local Embed = require("discorddotlua.objects.embed")

local embed = Embed:new()
    :setTitle("discorddotlua")
    :setDescription("A Lua Discord library")
    :setColor(0x7289DA)

interaction:reply("", {
    embeds = { embed:toTable() }
})
Project Structure
Code
discorddotlua/
│
├── package.lua
├── init.lua
├── client.lua
├── gateway.lua
├── rest.lua
│
└── objects/
    ├── message.lua
    ├── channel.lua
    ├── user.lua
    ├── guild.lua
    ├── member.lua
    ├── role.lua
    ├── interaction.lua
    ├── embed.lua
    ├── attachment.lua
    ├── emoji.lua
    ├── thread.lua
    ├── webhook.lua
    ├── sticker.lua
    ├── voice_state.lua
    └── invite.lua
License
discorddotlua is released under the MIT License.

Contributing
Contributions are welcome. Feel free to open issues, request features, or submit pull requests.
