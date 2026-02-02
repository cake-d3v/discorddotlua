local Role = {}
Role.__index = Role

function Role:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        color = data.color,
        hoist = data.hoist,
        position = data.position,
        permissions = data.permissions,
        managed = data.managed,
        mentionable = data.mentionable,
        raw = data,
        client = client
    }, Role)
end

return Role
