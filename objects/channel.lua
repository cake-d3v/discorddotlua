local Channel = {}
Channel.__index = Channel

function Channel:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        type = data.type,
        topic = data.topic,
        guild_id = data.guild_id,
        raw = data,
        client = client
    }, Channel)
end

function Channel:send(text)
    return self.client.rest:sendMessage(self.id, text)
end

return Channel
