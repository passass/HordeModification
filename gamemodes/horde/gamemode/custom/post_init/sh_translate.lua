for i, filename in pairs(file.Find("horde/gamemode/custom/post_init/languages/*.lua", "LUA")) do
	LANGUAGE = {}
	AddCSLuaFile("languages/" .. filename)
	include("languages/" .. filename)
	for k, v in pairs(LANGUAGE) do
		translate.AddTranslation(k, v)
	end
	LANGUAGE = nil
end