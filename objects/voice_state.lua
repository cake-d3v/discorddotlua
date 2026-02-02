local VoiceState = {}
VoiceState.__index = VoiceState

function VoiceState:new(data, client)
    return setmetatable({
        guild_id = data.guild_id,
        channel_id = data.channel_id,
        user_id = data.user_id,
        session_id = data.session_id,
        deaf = data.deaf,
        mute = data.mute,
        self_deaf = data.self_deaf,
        self_mute = data.self_mute,
        raw = data,
        client = client
    }, VoiceState)
end

return VoiceState
