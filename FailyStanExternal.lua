-- Load CTLD & CSAR
local FailyLfs = require('lfs')
dofile(FailyLfs.writedir()..'/Scripts/Failystan/CTLD_Failystan.lua')
dofile(FailyLfs.writedir()..'/Scripts/Failystan/CSAR_Failystan.lua')
dofile(FailyLfs.writedir()..'/Scripts/Failystan/Moose_Failystan.lua')






CivFailyIncList = { "Template Civ Faily Inc 1", "Template Civ Faily Inc 2" }

CivFailyInc1Spawn = SPAWN:New("Template Civ Faily Inc 1"):InitLimit(2,2):InitRandomizeRoute(0, 1, 5000):SpawnScheduled(600, 0.3)

CivFailyInc2Spawn = SPAWN:New("Template Civ Faily Inc 2"):InitLimit(2,2):InitRandomizeRoute(0, 1, 5000):SpawnScheduled(600, 0.3)

CivFailyOut1Spawn = SPAWN:New("Template Civ Faily Out 1"):InitLimit(2,2):InitRandomizeRoute(0, 1, 35000):SpawnScheduled(600, 0.3)


-- resources - FARP, barracks, bases, planes, etc....

failystan.resources = {}

failystan.resources.farps = { 'FARP_TSKHINVALI' , 'FARP_ALPES_OUEST' }

for _,farpZone in ipairs(failystan.resources.farps) do
	ctld.createRadioBeaconAtZone(farpZone,"blue", 1440,farpZone)
end


-- sides definition
failystan.faily = {}
failystan.rusW = {}
failystan.rusN = {}

for side, value in pairs(failystan) do
	failystan[side].spawning = {}
	failystan[side].sets = {}
end


failystan.faily.mainHQ = COMMANDCENTER:New( STATIC:FindByName( "HQ" ), "HQ" )

-- Definition des templates spawn
failystan.faily.spawning.CAPTemplates = { 'Regular CAP FailyStan 1', 'Regular CAP FailyStan 2' , 'Regular CAP FailyStan 3' , 'Regular CAP FailyStan 4' , 'Regular CAP FailyStan 5' }
failystan.faily.spawning.CAPSpawn = SPAWN:New('Regular CAP FailyStan 1'):InitRandomizeTemplate( failystan.faily.spawning.CAPTemplates ):InitRepeat()

failystan.faily.spawning.CAP = failystan.faily.spawning.CAPSpawn:Spawn()

failystan.rusW.spawning.CAPTemplates = { 'Regular CAP RUS W 1' , 'Regular CAP RUS W 2' , 'Regular CAP RUS W 3' , 'Regular CAP RUS W 4' , 'Regular CAP RUS W 5' , 'Regular CAP RUS W 6' , 'Regular CAP RUS W 7' }
failystan.rusW.spawning.CAPSpawn = SPAWN:New('Regular CAP RUS W 1'):InitRandomizeTemplate( failystan.rusW.spawning.CAPTemplates ):InitRepeat()

failystan.rusW.spawning.CAP = failystan.rusW.spawning.CAPSpawn:Spawn()


-- Sets definition
failystan.faily.sets.HeliClient = SET_CLIENT:New():FilterCoalitions("blue"):FilterCategories("helicopter"):FilterStart()

failystan.faily.sets.TranspHeliGroup = SET_GROUP:New():FilterPrefixes( { "=F= Mi8", "=F= UH1" } ):FilterStart()

failystan.faily.sets.SAMGroup = SET_GROUP:New():FilterPrefixes( { "SAM Faily" } ):FilterStart()

failystan.faily.sets.AAGroup = SET_GROUP:New():FilterPrefixes( { "=F= M2000" , "=F= Mig21" } ):FilterStart()

[[--
-- EWR definition
failystan.faily.ewrDetection = DETECTION_BASE:New( failystan.faily.sets.SAMGroup, 115000 )
failystan.faily.ewrMission = FAILY_MISSION:New( failystan.faily.mainHQ, 'Airspace Security', 'Primary', 'Keep Failystan airspace secure!', "Failystan" )
failystan.faily.ewrDispatcher = DETECTION_DISPATCHER:New( failystan.faily.ewrMission, failystan.faily.mainHQ, failystan.faily.sets.AAGroup , failystan.faily.ewrDetection )


failystan.transportLocs = { 'LOC_1', 'LOC_2', 'LOC_3', 'LOC_4', 'LOC_5' }
local transportMission = MISSION:New( failystan.faily.mainHQ, 'Transport troops', "Primary", "Transport our troops to their new home", "Failystan" )
local randChoice = mist.random(5)
transportTargetGroup = ctld.spawnGroupAtTrigger("blue", 10, failystan.transportLocs[randChoice], 100)

local transportTask = TASK_BASE:New( transportMission, failystan.faily.sets.TranspHeliGroup, "Mission de Transport", "Troupes", "Transport" )

transportMission:AddTask( transportTask )

local tmpLocs = failystan.transportLocs 
-- tmpLocs[randChoice] = nil
randChoice = mist.random(5)
transportTargetZone = failystan.transportLocs[randChoice]

-- local TaskTransport = TASK_BASE:New(transportMission, 
--]]



