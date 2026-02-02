local Invite = {}
Invite.__index = Invite

function Invite:new(data, client)
    return setmetatable({
        code = data.code,
        guild = data.guild,
        channel = data.channel,
        inviter = data.inviter,
        uses = data.uses,
        max_uses = data.max_uses,
        max_age = data.max_age,
        temporary = data.temporary,
        created_at = data.created_at,
        raw = data,
        client = client
    }, Invite)
end

return Invite
