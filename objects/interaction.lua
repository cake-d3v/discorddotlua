local Interaction = {}
Interaction.__index = Interaction

function Interaction:new(data, client)
    return setmetatable({
        id = data.id,
        application_id = data.application_id,
        type = data.type,
        data = data.data,
        guild_id = data.guild_id,
        channel_id = data.channel_id,
        member = data.member,
        user = data.user,
        token = data.token,
        version = data.version,
        raw = data,
        client = client
    }, Interaction)
end

function Interaction:reply(content, opts)
    opts = opts or {}
    return self.client.rest:replyInteraction(self.id, self.token, {
        content = content,
        flags = opts.ephemeral and 64 or nil
    })
end

function Interaction:defer(ephemeral)
    return self.client.rest:replyInteraction(self.id, self.token, {
        type = 5,
        data = {
            flags = ephemeral and 64 or nil
        }
    })
end

return Interaction
