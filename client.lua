local WebSocket = require("coro-websocket")
local json = require("json")
local Gateway = require("./gateway")
local REST = require("./rest")

local Message = require("./objects/message")
local Channel = require("./objects/channel")
local User = require("./objects/user")
local Guild = require("./objects/guild")

local Client = {}
Client.__index = Client

-- Default intents: GUILDS + GUILD_MESSAGES + MESSAGE_CONTENT
local DEFAULT_INTENTS = bit.bor(
    1 << 0,   -- GUILDS
    1 << 9,   -- GUILD_MESSAGES
    1 << 15   -- MESSAGE_CONTENT
)

function Client:new(token, opts)
    opts = opts or {}
    return setmetatable({
        token = token,
        events = {},
        rest = REST:new(token),
        intents = opts.intents or DEFAULT_INTENTS,
        presence = opts.presence or nil,

        guilds = {},   -- cache: [id] = Guild
        channels = {}, -- cache: [id] = Channel
        users = {},    -- cache: [id] = User
    }, Client)
end

function Client:on(event, callback)
    self.events[event] = callback
end

function Client:setPresence(presence)
    -- presence: { status = "online", activities = { { name = "NovaCord", type = 0 } } }
    self.presence = presence
    if self._gateway then
        self._gateway:updatePresence(presence)
    end
end

function Client:cacheGuild(data)
    local guild = Guild:new(data, self)
    self.guilds[guild.id] = guild
    return guild
end

function Client:cacheChannel(data)
    local channel = Channel:new(data, self)
    self.channels[channel.id] = channel
    return channel
end

function Client:cacheUser(data)
    local user = User:new(data, self)
    self.users[user.id] = user
    return user
end

-- Slash command registration (global)
function Client:registerGlobalCommand(appId, command)
    return self.rest:registerGlobalCommand(appId, command)
end

-- Slash command registration (guild)
function Client:registerGuildCommand(appId, guildId, command)
    return self.rest:registerGuildCommand(appId, guildId, command)
end

-- Internal event wrapping
function Client:emit(event, data)
    if event == "READY" then
        -- cache guilds from READY
        if data.guilds then
            for _, g in ipairs(data.guilds) do
                self:cacheGuild(g)
            end
        end
    elseif event == "GUILD_CREATE" then
        data = self:cacheGuild(data)
    elseif event == "CHANNEL_CREATE" or event == "CHANNEL_UPDATE" then
        data = self:cacheChannel(data)
    elseif event == "MESSAGE_CREATE" then
        data = Message:new(data, self)
    elseif event == "USER_UPDATE" then
        data = self:cacheUser(data)
    elseif event == "INTERACTION_CREATE" then
        -- keep raw for now; you can wrap later
        -- data.type == 2 => application command
    end

    if self.events[event] then
        self.events[event](data)
    end
end

function Client:run()
    self._gateway = Gateway.new(self)
    self._gateway:connect()
end

return Client
