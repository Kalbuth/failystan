--FailyStan classes definitions - overrides Moose


-- Adding to Moose Set functionalities

function SET_UNIT:HasAirUnits()
  self:F2()

  local AirUnitCount = 0
  for UnitID, UnitData in pairs( self:GetSet()) do
    local UnitTest = UnitData -- Unit#UNIT
    if UnitTest:IsAir() then
      AirUnitCount = AirUnitCount + 1
    end
  end

  return AirUnitCount
end


do
	DETECTION_GCI = {
		ClassName = DETECTION_GCI,
		DetectionZone = {},
	}
	function DETECTION_GCI:New(DetectionSetGroup, DetectionRange, DetectionZone, Mission, CommandCenter, Frequency)
		-- Inherits from DETECTION_BASE
		local self = BASE:Inherit( self, DETECTION_BASE:New( DetectionSetGroup, DetectionRange ) )
		
		self.DetectionZone = DetectionZone
		self.Mission = Mission
		self.CommandCenter = CommandCenter
		self.Frequency = Frequency
		self.DetectedSets = SET_UNIT:New()
		self:SetFrequency( Frequency )
		self:SetCallsign( 1 )
		self:_InitRadio()
		
		self:Schedule(0, 30)
		
		return self
	end
	
	function DETECTION_GCI:SetFrequency(Frequency)
		-- sets the emitter frequency for GCI Command Center
		self:F2( Frequency )
		local SetFrequency = {
			['id'] = 'SetFrequency',
			['params'] = {
				['frequency'] = Frequency,
				['modulation'] = 0,
			},
		}
		self.CommandCenter:SetCommand( SetFrequency )
	end

	function DETECTION_GCI:SetCallsign( Callsign )
		-- sets the emitter callsign for GCI Command Center
		self:F2( Callsign )
		local SetCallsign = {
			['id'] = 'SetCallsign',
			['params'] = {
				['callname'] = Callsign,
				['number'] = 1,
			},
		}
		self.CommandCenter:SetCommand( SetCallsign )
	end
	
	function DETECTION_GCI:_InitRadio()
		self:F2()
		self:E('adding GCI menu')
		local coal = self.CommandCenter:GetCoalition()
		if not self.MenuGCI then
			self.MenuGCI = MENU_COALITION:New( coal, "GCI" )
		end
		self:E('adding Picture entry')
		self.MenuCmdPicture = MENU_COALITION_COMMAND:New( coal, "Request Picture", self.MenuGCI, self.GetPicture, { self = self } )
	end
	
	function DETECTION_GCI.GetPicture( PictureParams )
		local self = PictureParams.self
		-- self:F2()
		local TransmitMessage = { 
			['id'] = 'TransmitMessage', 
			['params'] = {
				['duration'] = 15,
				['subtitle'] = "This is a EWR test message",
				['loop'] = false,
				['file'] = "l10n/DEFAULT/beaconsilent.ogg",
			},
		}
		if self.CommandCenter then
			self.CommandCenter:SetCommand( TransmitMessage )
		end
		-- to be continued
		-- DETECION_GCI:CreateDetectionSets() a faire
		-- cf Detection.lua l. 796 & 905
		-- for UnitID, UnitData in pairs( self.DetectedSets:GetSet() ) do
		-- 	local DetectedUnit = UnitData
		--end
	end
	
	function DETECTION_GCI:CreateDetectionSets()
		self:F2()
		self.DetectedSets = nil
		self.DetectedSets = SET_UNIT:New()
		for DetectedUnitName, DetectedObjectData in pairs( self.DetectedObjects ) do
			local DetectedObject = self:GetDetectedObject( DetectedUnitName )
			if DetectedObject then
				local DetectedUnit = UNIT:FindByName( DetectedUnitName )
				if DetectedUnit and DetectedUnit:IsAir() then
					self.DetectedSets:AddUnit( DetectedUnit )
				end
			end
		end
		
	end
	
	


end
