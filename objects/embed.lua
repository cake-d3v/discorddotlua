local Embed = {}
Embed.__index = Embed

function Embed:new()
    return setmetatable({
        title = nil,
        description = nil,
        url = nil,
        color = nil,
        fields = {},
        footer = nil,
        image = nil,
        thumbnail = nil
    }, Embed)
end

function Embed:setTitle(title)
    self.title = title
    return self
end

function Embed:setDescription(desc)
    self.description = desc
    return self
end

function Embed:setColor(color)
    self.color = color
    return self
end

function Embed:addField(name, value, inline)
    table.insert(self.fields, {
        name = name,
        value = value,
        inline = inline or false
    })
    return self
end

function Embed:toTable()
    return {
        title = self.title,
        description = self.description,
        url = self.url,
        color = self.color,
        fields = self.fields,
        footer = self.footer,
        image = self.image,
        thumbnail = self.thumbnail
    }
end

return Embed
