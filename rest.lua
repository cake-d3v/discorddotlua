local http = require("coro-http")
local json = require("json")

local REST = {}
REST.__index = REST

local BASE = "https://discord.com/api/v10"

function REST:new(token)
    return setmetatable({
        token = token
    }, REST)
end

function REST:request(method, path, body)
    local headers = {
        {"Authorization", "Bot " .. self.token},
        {"Content-Type", "application/json"}
    }

    local res, data = http.request(method, BASE .. path, headers, body and json.encode(body))
    local status = res.code
    if not data or #data == 0 then
        return nil, status
    end
    return json.decode(data), status
end

-- Messages
function REST:sendMessage(channelId, content)
    return self:request("POST", "/channels/" .. channelId .. "/messages", {
        content = content
    })
end

-- Slash commands
function REST:registerGlobalCommand(appId, command)
    return self:request("POST", "/applications/" .. appId .. "/commands", command)
end

function REST:registerGuildCommand(appId, guildId, command)
    return self:request("POST", "/applications/" .. appId .. "/guilds/" .. guildId .. "/commands", command)
end

function REST:replyInteraction(interactionId, token, data)
    return self:request("POST", "/interactions/" .. interactionId .. "/" .. token .. "/callback", {
        type = 4,
        data = data
    })
end

-- Moderation
function REST:ban(guildId, userId, reason, deleteMessageDays)
    return self:request("PUT", "/guilds/" .. guildId .. "/bans/" .. userId, {
        delete_message_days = deleteMessageDays or 0,
        reason = reason
    })
end

function REST:unban(guildId, userId, reason)
    return self:request("DELETE", "/guilds/" .. guildId .. "/bans/" .. userId, {
        reason = reason
    })
end

function REST:kick(guildId, userId, reason)
    return self:request("DELETE", "/guilds/" .. guildId .. "/members/" .. userId, {
        reason = reason
    })
end

-- Timeout (communication_disabled_until)
function REST:timeout(guildId, userId, untilIso8601, reason)
    return self:request("PATCH", "/guilds/" .. guildId .. "/members/" .. userId, {
        communication_disabled_until = untilIso8601,
        reason = reason
    })
end

return REST
