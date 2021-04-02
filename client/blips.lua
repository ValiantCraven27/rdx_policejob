local blips = {
 

{ name = 'Sheriff Office', sprite = 1322310532, x = -275.06, y = 805.0, z = 119.38},      -- valentine
{ name = 'Sheriff Office', sprite = 1322310532, x = -764.91, y = -1271.96, z = 43.85},   --blackwater
{ name = 'Sheriff Office', sprite = 1322310532, x = 1361.12, y = -1304.57, z = 77.77},   --rhodes
{ name = 'Sheriff Office', sprite = 1322310532, x = -1813.57, y = -354.83, z = 164.65},  --strawberry
{ name = 'Sheriff Office', sprite = 1322310532, x = -5527.06, y = -2928.43, z = -1.36},  --tumbleweed
{ name = 'Sheriff Office', sprite = 1322310532, x = -3625.28, y = -2601.66, z = -13.34},   --armadillo
{ name = 'Sheriff Office', sprite = 1322310532, x = 2906.44, y = 1314.93, z = 44.94},  --annesburg
{ name = 'Sheriff Office', sprite = 1322310532, x= 2908.7, y = 1312.14, z = 44.94},     -- Saint Denise

}
      
Citizen.CreateThread(function()
	for _, info in pairs(blips) do
        local blip = N_0x554d9d53f696d002(1664425300, info.x, info.y, info.z) -- ADD BLIP FOR COORDS
        SetBlipSprite(blip, info.sprite, 1)
		SetBlipScale(blip, 0.4)
                                Citizen.InvokeNative(0x9CB1A1623062F402, blip, info.name) -- TEXT STRING
    end  
end)


