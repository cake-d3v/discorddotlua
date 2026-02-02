local Thread = {}
Thread.__index = Thread

function Thread:new(data, client)
    return setmetatable({
        id = data.id,
        name = data.name,
        guild_id = data.guild_id,
        parent_id = data.parent_id,
        owner_id = data.owner_id,
        archived = data.thread_metadata and data.thread_metadata.archived,
        raw = data,
        client = client
    }, Thread)
end

function Thread:send(text)
    return self.client.rest:sendMessage(self.id, text)
end

return Thread
