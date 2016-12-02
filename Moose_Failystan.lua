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



-- Faily_CC : prise en charge des missions

FAILY_COMMANDCENTER = {
	ClassName = "FAILY_COMMANDCENTER",
}

function FAILY_COMMANDCENTER:New( HQ, HQName )
	
	local self = BASE:Inherit( self, COMMANDCENTER:New( HQ, HQName ) )
	
	self:F()
	
	self:EventOnBirth(
    --- @param Core.Event#EVENTDATA EventData
    function( HQ, EventData )
      self:E( { EventData } )
      local EventGroup = GROUP:Find( EventData.IniDCSGroup )
			self:E( { "Group Spawned, CC checking...",  EventGroup } )
      if EventGroup and HQ:HasGroup( EventGroup ) then
				self:E( { "Group has missions here!", EventGroup } )
        local MenuHQ = MENU_GROUP:New( EventGroup, "HQ" )
        local MenuReporting = MENU_GROUP:New( EventGroup, "Reporting", MenuHQ )
        local MenuMissions = MENU_GROUP_COMMAND:New( EventGroup, "Missions", MenuReporting, HQ.ReportMissions, HQ, EventGroup )
      end
    end
  )
	
	return self
	
end
	
failystan = {}

FAILY_MISSION = {
	ClassName = "FAILY_MISSION",
}

function FAILY_MISSION:New(HQ, MissionName, MissionPriority, MissionBriefing, MissionCoalition )

	local self = BASE:Inherit( self, MISSION:New(HQ, MissionName, MissionPriority, MissionBriefing, MissionCoalition ))
	
	self:E({ HQ, MissionName, MissionPriority, MissionBriefing, MissionCoalition })

	return self

end
	
failystan.MISSION_TRANSPORT = {
	ClassName = "MISSION_TRANSPORT",
}

function failystan.MISSION_TRANSPORT:New( HQ, MissionName, MissionPriority, MissionBriefing, MissionCoalition, TransportGroup, TransportDest )
	local self = BASE:Inherit( self, MISSION:New( HQ, MissionName, MissionPriority, MissionBriefing, MissionCoalition ) )
	self:F()
	
	self.TransportGroup = TransportGroup
	self.TransportDest = TransportDest
	return self
end


do
	DETECTION_GCI = {
		ClassName = DETECTION_ZONE,
		DetectionZone = {},
	}
	function DETECTION_GCI:New(DetectionSetGroup, DetectionRange, DetectionZone, Mission, CommandCenter, Frequency)
		-- Inherits from DETECTION_BASE
		local self = BASE:Inherit( self, DETECTION_BASE:New( DetectionSetGroup, DetectionRange ) )
		
		self.DetectionZone = DetectionZone
		self.Mission = Mission
		self.CommandCenter = CommandCenter
		self.Frequency = Frequency
		
		self:SetFrequency( Frequency )
		self:SetCallsign( 101 )
		self:_InitRadio()
		
		self.Schedule(0, 30)
		
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
		-- sets the emitter frequency for GCI Command Center
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
		local coal = self.CommandCenter:GetCoalition()
		if not self.MenuGCI then
			self.MenuGCI = MENU_COALITION:New( coal, "GCI" )
			self.MenuCmdPicture = MENU_COALITION_COMMAND:New( coal, "Request Picture", self.MenuGCI, self:GetPicture() )
		end
	end
	
	function DETECTION_GCI:GetPicture()
		self:F2()
		-- to be continued
		-- DETECION_GCI:CreateDetectionSets() a faire
		-- cf Detection.lua l. 796 & 905
		
		
	end
	
	
	FAILY_DETECTION_DISPATCHER = {
		 ClassName = "FAILY_DETECTION_DISPATCHER",
		 Mission = nil,
		 CommandCenter = nil,
		 Detection = nil,
	}
  function FAILY_DETECTION_DISPATCHER:New( Mission, CommandCenter, SetGroup, Detection )
  
    -- Inherits from DETECTION_DISPATCHER
    local self = BASE:Inherit( self, DETECTION_DISPATCHER:New( Mission, CommandCenter, SetGroup, Detection ) ) -- #DETECTION_DISPATCHER
    
    return self
  end


end
