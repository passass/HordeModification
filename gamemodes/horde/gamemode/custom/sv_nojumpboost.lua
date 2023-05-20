hook.Add("InitPostEntity", "Horde_RemoveJumpBoost", function(ply)
	local PLAYER = baseclass.Get("player_sandbox")

	PLAYER.FinishMove           = nil       -- Disable boost
	PLAYER.StartMove           	= nil       -- Disable boost
end)