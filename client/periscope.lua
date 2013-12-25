-- PERISCOPE v1.1 by Orinoco
-- Released 2013-12-25
-- This script sets camera position X meters below your head.
-- It is primarily intended for underwater view when being on a boat.
-- Syntax: /per <meters> for setting camera below, /per for reset 

class 'Periscope'

function Periscope:__init()
	
  self.depth = 0

	Events:Subscribe( "CalcView", self, self.CalcView )
	Events:Subscribe( "LocalPlayerChat", self, self.LocalPlayerChat )
  Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
  Events:Subscribe( "ModulesLoad", self, self.ModuleLoad )
  Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )
end

function Periscope:ModuleLoad()
  Events:Fire("HelpAddItem",{
    name = "Periscope",
    text = "Periscope sets camera position X meters below your head.\n"..
      "It is primarily intended for underwater view when being on a boat.\n"..
      "\n"..
      "Syntax:\n"..
      "/per <meters>      ... set the camera X meters below you\n"..
      "/per                       ... reset the camera to default"
  })
end
    
function Periscope:ModuleUnload()
    Events:Fire("HelpRemoveItem",{name = "Periscope"})
end

function Periscope:CalcView()
	if self.depth == 0 then return end
	local position = LocalPlayer:GetBonePosition( "ragdoll_Head" )
  position = position + (Camera:GetAngle() * Vector3( 0, -self.depth, 0 ))
	Camera:SetPosition( position )
end

function Periscope:LocalPlayerChat( args )
  local msg = args.text
	local split_msg = msg:split(" ")

	if split_msg[1] == "/per" then
		local value = tonumber( split_msg[2] )
		
	  if value ~= nil then
	  	if value < 0 then
			  Chat:Print("[Periscope] Please use a value over 0!", Color(210, 15, 15))
			  self.depth = 0
		  else
		    self.depth = value
		  end			
		else
			self.depth = 0
		end

	end
end

periscope = Periscope()