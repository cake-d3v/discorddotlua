local WebSocket = require("coro-websocket")
local json = require("json")

local Gateway = {}
Gateway.__index = Gateway

function Gateway.new(client)
    return setmetatable({
        client = client,
        seq = nil,
        session_id = nil,
        write = nil
    }, Gateway)
end

function Gateway:send(payload)
    if self.write then
        self.write(json.encode(payload))
    end
end

function Gateway:updatePresence(presence)
    self:send({
        op = 3,
        d = {
            since = nil,
            activities = presence.activities or {},
            status = presence.status or "online",
            afk = false
        }
    })
end

function Gateway:identify()
    self:send({
        op = 2,
        d = {
            token = self.client.token,
            intents = self.client.intents,
            properties = {
                os = "linux",
                browser = "novacord",
                device = "novacord"
            },
            presence = self.client.presence and {
                since = nil,
                activities = self.client.presence.activities or {},
                status = self.client.presence.status or "online",
                afk = false
            } or nil
        }
    })
end

function Gateway:connect()
    local url = "wss://gateway.discord.gg/?v=10&encoding=json"
    local res, read, write = WebSocket.connect(url)
    self.write = write

    for message in read do
        local payload = json.decode(message.payload)
        self.seq = payload.s or self.seq

        if payload.op == 10 then
            local interval = payload.d.heartbeat_interval

            coroutine.wrap(function()
                while true do
                    self:send({ op = 1, d = self.seq })
                    coroutine.sleep(interval / 1000)
                end
            end)()

            self:identify()
        elseif payload.op == 7 then
            -- reconnect
        elseif payload.op == 9 then
            -- invalid session
        elseif payload.op == 0 then
            local t = payload.t
            local d = payload.d

            if t == "READY" then
                self.session_id = d.session_id
            end

            self.client:emit(t, d)
        end
    end
end

return Gateway
