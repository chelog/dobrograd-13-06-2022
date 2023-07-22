
if CatmullRomCams.SH.GCStarted then return end

CatmullRomCams.SH.GCStarted = true

function CatmullRomCams.SH.GarbageCollectionBooster()
	collectgarbage()
	
	return timer.Simple(30, CatmullRomCams.SH.GarbageCollectionBooster)
end
timer.Simple(30, CatmullRomCams.SH.GarbageCollectionBooster) -- Now unneeded! :4chan: But reenabled beause it's not readily noticeable and it still helps. :wink:
