local Message = {}
Message.__index = Message

function Message:new(data, client)
    return setmetatable({
        id = data.id,
        content = data.content,
        channel_id = data.channel_id,
        author = data.author,
        guild_id = data.guild_id,
        raw = data,
        client = client
    }, Message)
end

function Message:reply(text)
    return self.client.rest:sendMessage(self.channel_id, text)
end

return Message
