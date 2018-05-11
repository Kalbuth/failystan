CallSigns = {
	[1]= "Axeman",	
	[2]= "Darknight",
	[3]= "Warrior",
	[4]= "Pointer",
	[5]= "Eyeball",	
	[6]= "Moonbeam",	
	[7]= "Whiplash",	
	[8]= "Finger",	
	[9]= "Pinpoint",	
	[10]= "Ferret",	
	[11]= "Shaba",	
	[12]= "Playboy",	
	[13]= "Hammer",	
	[14]= "Jaguar",	
	[15]= "Deathstar",	
	[16]= "Anvil",	
	[17]= "Firefly",	
	[18]= "Mantis",
	[19]= "Badger",
}

function GenerateReport(DetectedItems, FACName, FACFreq)
	local Report = "We have troops in contact with the enemy."
	local Contacts = {}
	local Count = 0
	for Id, Item in pairs(DetectedItems) do
		Count = Count + 1
		Contacts[Id] = {}
		Contacts[Id].Text = Item.ThreatText
		local Coord = COORDINATE:NewFromVec2(Item.Zone.LastVec2)
		Contacts[Id].Coord = Coord:ToStringLLDDM()
	end
	Report = Report .. " " .. Count .. " group(s) detected : \n"
	for Id, Contact in pairs(Contacts) do
		Report = Report .. "Group " .. Id .. " of " .. Contact.Text .. " at " .. Contact.Coord .. ".\n"
	end
	Report = Report .. "You can contact friendly group " .. FACName .. " on frequency " .. FACFreq .. " MHz."
	return Report
end

USGroup = GROUP:FindByName("US_G_1")
USGroup.Engaged = false
USGroup.LastTransmission = 11
USGroup.Callsign = "Wolfpack 3"
USGroup.Frequency = 131000000
USGroup.Radio = USGroup:GetRadio()
USGroup.Radio:SetFileName("beaconsilent.ogg")
USGroup.Radio:SetFrequency(131)
USGroup.Radio:SetModulation(radio.modulation.AM)
USGroup.Radio:SetPower(20)
USGroup.Radio:SetLoop(false)
USGroup.Radio:SetSubtitle("", 0 )
USSetGroup = SET_GROUP:New():AddGroupsByName("US_G_1")
USDetect = DETECTION_AREAS:New(USSetGroup, 500)
USDetect:SetAcceptRange( 5000 )
USDetect.LocalGroup = "US_G_1"
USDetect:Start()
USDetect.OnAfterDetect = function (self, From, Event, To)
	local Count = 0
	local SpawnGroup = GROUP:FindByName(self.LocalGroup)
	self:E("Detection routine for : " .. routines.utils.oneLineSerialize(SpawnGroup) )
	for Index, Value in pairs( self.DetectedObjects ) do
		Count = Count + 1
	end
	if Count > 0 then 
		if SpawnGroup.Engaged == false then 
			SpawnGroup.Engaged = true
			local StopZone = ZONE_GROUP:New("Stop_Zone_" .. SpawnGroup.GroupName, SpawnGroup, 300)
			SpawnGroup:TaskRouteToZone( StopZone, true, 25, "Vee" )
			SpawnGroup:EnRouteTaskFAC( 5000, 5)
		end
		if SpawnGroup.LastTransmission > 2 then 
			SpawnGroup.LastTransmission = -1
			self:E( "DETECTED GROUP COMPOSITION IS :  " .. routines.utils.oneLineSerialize(self.DetectedItems) )
			local DetectionReport = GenerateReport(self.DetectedItems, SpawnGroup.Callsign , SpawnGroup.Frequency / 1000000)
			SpawnGroup.Radio:SetSubtitle( DetectionReport, 30 )
			SpawnGroup.Radio:Broadcast()
		end
		SpawnGroup.LastTransmission = SpawnGroup.LastTransmission + 1
	end
	if ( ( Count == 0 ) and ( SpawnGroup.Engaged == true ) ) then
		SpawnGroup.Engaged = false
--		SpawnGroup:TaskRouteToZone( Warzone.North.Zones[Warzone.North.RedIndex], false, 15, "On Road" )
	end
end