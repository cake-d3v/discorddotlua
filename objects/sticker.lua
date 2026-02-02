local Sticker = {}
Sticker.__index = Sticker

function Sticker:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        description = data.description,
        tags = data.tags,
        format_type = data.format_type,
        raw = data,
        client = client
    }, Sticker)
end

return Sticker
