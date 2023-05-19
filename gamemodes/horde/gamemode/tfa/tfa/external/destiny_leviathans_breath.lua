local bow = "weapons/leviathansbreath/"

TFA.AddFireSound("TFA_LEVIATHANSBREATH_FIRE.1", { bow .. "leviathansbreathFire1.wav", bow .. "leviathansbreathFire2.wav", bow .. "leviathansbreathFire3.wav"}, true, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_DRYFIRE.1", CHAN_AUTO, 0.6, 80, {97, 103},  { bow .. "leviathansbreathdryFire1.wav", bow .. "leviathansbreathdryFire2.wav"}, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_DRAW.1", CHAN_AUTO, 1, 100, {97, 103},  { bow .. "leviathansbreathdraw1.wav", bow .. "leviathansbreathdraw2.wav"}, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_DEPLOY.1", CHAN_AUTO, 0.6, 80, {97, 103},  { bow .. "LeviathansBreathDeploy.wav"}, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_IRONIN.1", CHAN_AUTO, 0.6, 80, {97, 103},  { bow .. "LeviathansBreathIronIn.wav"}, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_IRONOUT.1", CHAN_AUTO, 0.6, 80, {97, 103},  { bow .. "LeviathansBreathIronOut.wav"}, ")" )
TFA.AddSound("TFA_LEVIATHANSBREATH_RELOAD.1", CHAN_AUTO, 0.5, 80, {97, 103},  { bow .. "LeviathansBreathReload1.wav", bow .. "LeviathansBreathReload2.wav", bow .. "LeviathansBreathReload3.wav"}, ")" )


local icol = Color( 255, 100, 0, 255 ) 
if CLIENT then
	killicon.Add(  "destiny_leviathans_breath",	"vgui/killicons/destiny_leviathans_breath", icol  )
end
