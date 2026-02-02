local Attachment = {}
Attachment.__index = Attachment

function Attachment:new(data, client)
    return setmetatable({
        id = data.id,
        filename = data.filename,
        size = data.size,
        url = data.url,
        proxy_url = data.proxy_url,
        height = data.height,
        width = data.width,
        content_type = data.content_type,
        raw = data,
        client = client
    }, Attachment)
end

return Attachment
