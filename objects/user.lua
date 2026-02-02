local User = {}
User.__index = User

function User:new(data, client)
    return setmetatable({
        id = data.id,
        username = data.username,
        discriminator = data.discriminator,
        global_name = data.global_name,
        avatar = data.avatar,
        bot = data.bot,
        raw = data,
        client = client
    }, User)
end

return User
