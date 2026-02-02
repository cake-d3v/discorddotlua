local Guild = {}
Guild.__index = Guild

function Guild:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        owner_id = data.owner_id,
        icon = data.icon,
        raw = data,
        client = client
    }, Guild)
end

return Guild
