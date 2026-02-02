local Webhook = {}
Webhook.__index = Webhook

function Webhook:new(data, client)
    return setmetatable({
        id = data.id,
        type = data.type,
        guild_id = data.guild_id,
        channel_id = data.channel_id,
        name = data.name,
        avatar = data.avatar,
        token = data.token,
        raw = data,
        client = client
    }, Webhook)
end

return Webhook
