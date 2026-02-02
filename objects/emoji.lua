local Emoji = {}
Emoji.__index = Emoji

function Emoji:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        roles = data.roles or {},
        animated = data.animated,
        raw = data,
        client = client
    }, Emoji)
end

return Emoji
