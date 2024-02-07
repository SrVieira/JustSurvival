Loader = { }
local mods = { }
local isReady = false;

--[[
Format:
mods['New Mod Name'] = {
	name = "New Mod Name",
	dff = "file_to_dff.dff",
	txd = "file_to_txd.txd",
	replace = vehicle_replace_id,
	dff_hash = MD5_of_dff_file,
	txd_hash = MD5_of_txd_file
}
]]

-- Loader Constructor 
function Loader:Loader ( )
	mods = { }
	if ( not ( File.exists ( "smods.xml" ) ) ) then 
		-- File functions are a lot easier to use than XML functions
		
		-- smods.xml doesnt exist - create new
		local t = File.new ( "smods.xml" );
		local str = [[
<mods>
    
    <!-- 
		
		ADDING CUSTOM VEHICLES
		-----------------------------------------------------------------------------------
		This is the mod list file.
		This file is used to get the modded files for the clients
		Add your mod by adding:
		<mod name="Modded Vehicle Name" txd="path to txd file" dff="path to dff file" replace="replace vehicle id" />
		
		name: This is the name of the new vehicle, the name that the clients will see
		txd: This is the load path for the modded (don't include "mods/vehicles") skin txd file inside mods folder 
		dff: This is the load path for the modded (don't include "mods/vehicles") skin dff file inside mods folder
		replace: The vehicle replace ID. Find GTA SA vehicle ids @ http://wiki.multitheftauto.com/wiki/Vehicle_IDs 
		-----------------------------------------------------------------------------------
	
	-->
    <vehicles>
        <!-- Examples (Won't work because you don't have the txd/dff files) 
        <mod name="2014 Range Rover Vogue" txd="huntley_2014_Range_Rover_Vogue.txd" dff="huntley_2014_Range_Rover_Vogue.dff" replace="579" /> -->
		
    </vehicles>
    
    
    <!-- 
		
		ADDING CUSTOM SKINS
		-----------------------------------------------------------------------------------
		This is the mod list file.
		This file is used to get the modded files for the clients
		Add your mod by adding:
		<mod name="Modded Skin Name" txd="path to txd file" dff="path to dff file" replace="replace skin id" />
		
		name: This is the name of the new skin, the name that the clients will see
		txd: This is the load path for the modded (don't include "mods/skins") skin txd file inside mods folder 
		dff: This is the load path for the modded (don't include "mods/skins") skin dff file inside mods folder
		replace: The skin replace ID. Find GTA SA skin ids @ https://wiki.sa-mp.com/wiki/Skins:All
		-----------------------------------------------------------------------------------
		
	-->
    <skins>
        <!-- Examples (Won't work because you don't have the txd/dff files)
        <mod name="Kokoro Arsenal Clothes" txd="hfyri.txd" dff="hfyri.dff" replace="40" /> -->
		
    </skins>
    
    
    <!-- 
		
		ADDING CUSTOM WEAPONS
		-----------------------------------------------------------------------------------
		This is the mod list file.
		This file is used to get the modded files for the clients
		Add your mod by adding:
		<mod name="Modded Weapon Name" txd="path to txd file" dff="path to dff file" replace="replace weapon model" />
		
		name: This is the name of the new weapon, the name that the clients will see
		txd: This is the load path for the modded (don't include "mods/weapons") weapon txd file inside mods folder 
		dff: This is the load path for the modded (don't include "mods/weapons") weapon dff file inside mods folder
		replace: The weapon replace Model (NOT ID!!!!). Find GTA SA weapon models @ https://wiki.sa-mp.com/wiki/Weapons
		-----------------------------------------------------------------------------------
		
	-->
    <weapons>
        <!-- Examples (Won't work because you don't have the txd/dff files)
        <mod name="Improved Fire Extinguisher" txd="366.txd" dff="366.dff" replace="366" /> -->
		
    </weapons>
    
</mods>
]]
		t:write ( str );
		t:close ( );
		t = nil;
		
		outputDebugString ( "smods.xml wasn't detected, but has been created!" );
		
	end 
	
	local metaFiles = { }
	local meta = XML.load ( "meta.xml" );
	
	for i, v in pairs ( meta.children ) do 
		if ( v.name == "file" and v:getAttribute ( "src" ) ) then 
			metaFiles [ v:getAttribute ( "src" ) ] = true;
		end 
	end 
	
	
	-- Load server-side mod list file (smods.xml)
	local xml = XML.load ( "smods.xml" );
	
	-- Check to make sure the XML was successfully loaded, if not delete & retry
	if ( not xml ) then 
		File.delete ( "smods.xml" );
		Loader:Loader ( );
		outputDebugString ( "smods.xml was unable to be loaded. Deleted file, retrying." );
		return;
	end 
	
	-- Loop all the "mod" children 
	local changesMade = false;
	for _index, _childNode in pairs ( xml.children ) do 

		for findex, childNode in pairs ( _childNode.children ) do
			
			local index = _index..":"..findex;
			
			local category = tostring ( childNode.parent.name ):lower();

			-- Confirm it's a "mod" child
			if ( childNode.name == "mod" ) then 
				-- Check if it has all the attributes
				local temp = { }
				temp.name = childNode:getAttribute ( "name" );
				temp.txd = childNode:getAttribute ( "txd" );
				temp.dff = childNode:getAttribute ( "dff" );
				temp.replace = childNode:getAttribute ( "replace" );
				temp.type = category;
				
				if ( temp.type == "skins" or temp.type == "vehicles" or temp.type == "weapons" ) then
					if ( temp.name and temp.txd and temp.dff and temp.replace ) then 
						-- confirm txd file exists 
						if ( File.exists ( "mods/" .. category .. "/" .. temp.txd ) ) then 
							temp.txd = "mods/" .. category .."/".. temp.txd;
							-- confirm dff file exists 
							if ( File.exists ( "mods/" .. category .. "/".. temp.dff ) ) then
								temp.dff =  "mods/" .. category .."/".. temp.dff;
								-- confirm replace is an integer, and a valid vehicle model 
								temp.replace = tonumber ( temp.replace );
								
								if ( 
									( temp.type == "vehicles" and 
									temp.replace and 
									math.floor ( temp.replace ) == temp.replace and 
									temp.replace >= 400 and 
									temp.replace <= 611 ) 
								or ( 
									temp.type == "skins" and 
									temp.replace and 
									math.floor ( temp.replace ) == temp.replace and 
									temp.replace >= 0 and 
									temp.replace <= 311 )
								or ( 
									temp.type == "weapons" and 
									temp.replace and 
									math.floor ( temp.replace ) == temp.replace and 
									temp.replace >= 321 and 
									temp.replace <= 372 )
								) then 
									
									
									-- Confirm there's actually a name 
									if ( temp.name:gsub ( " ", "" ) ~= "" ) then 
										-- Confirm name isn't already in use 
										if ( not mods [ temp.name ] ) then
											-- all checks are OK -- Encrypt and add to mod list 
											local tmp = File( temp.txd, true );
											temp.txd_hash = md5 ( tmp:read ( tmp.size ) );
											tmp:close ( );
											
											local tmp = File( temp.dff, true );
											temp.dff_hash = md5 ( tmp:read ( tmp.size ) );
											tmp:close ( );
											
											tmp = nil;
											
											if ( not metaFiles [ temp.txd ] ) then 
												outputDebugString ( temp.txd.. " not found in meta -- adding now" );
												
												local c = meta:createChild ( "file" );
												c:setAttribute ( 'src', temp.txd );
												c:setAttribute ( "download", "false" );
												changesMade = true;
											end 
											
											if ( not metaFiles [ temp.dff ] ) then 
												outputDebugString ( temp.dff.. " not found in meta -- adding now" );
												
												local c = meta:createChild ( "file" );
												c:setAttribute ( 'src', temp.dff );
												c:setAttribute ( "download", "false" );
												changesMade = true;
											end 
											
											
											outputDebugString ( "Successfully loaded mod #"..tostring(index).." - "..tostring ( temp.name ).. "!" );
											
											mods [ temp.name ] = temp;
										else 
											outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - Mod name already used" );
										end
											
									else
										outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - Invalid name" );
									end 
								else 
									if ( temp.type == "vehicles" ) then
										outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - replace must be an integer from 400-611" );
									elseif ( temp.type == "skins" ) then
										outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - replace must be an integer from 0-311" );
									elseif ( temp.type == "weapons" ) then
										outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - replace must be an integer from 331-371" );
									end
								end 
							else
								outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - dff file not found on server" );
							end 
						else 
							outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - txd file not found on server" );
						end 
					else 
						outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - not all attributes found" );
					end 
				else 
					outputDebugString ( "Failed to load #"..tostring(index).." ("..tostring(temp.name)..") - Unknown mod type, valid: skins, vehicles, weapons" );
				end 
			end 
		
		end
		
	end 
	
	
	xmlSaveFile( meta );
	xmlUnloadFile ( meta );
	
	xmlSaveFile ( xml );
	xmlUnloadFile ( xml );
	
	if ( changesMade ) then 
		outputDebugString ( "CHANGES HAVE BEEN MADE TO META.XML! RESTARTING RESOURCE...", 0, 255, 255, 255 );
		restartResource ( getThisResource ( ) );
		return;
	end 
	
	isReady = true;
	
	
end 

setTimer ( Loader.Loader, 2000, 1 );

-- Loader:HandleRequest -> Handles request of mod files from client
-- Sends client new mod list
function Loader:HandleRequest ( plr )
	triggerClientEvent ( source, "ModDownloader:OnServerSendClientModList", source, mods );
end 
addEvent ( "ModDownloader:RequestFilesFromServer", true );
addEventHandler ( "ModDownloader:RequestFilesFromServer", root, Loader.HandleRequest );

--addEventHandler ( "onResourceStart", resourceRoot, Loader.Loader );

addEvent ( "ModDownloader:TestServerReadyForClient", true );
addEventHandler ( "ModDownloader:TestServerReadyForClient", root, function ( )
	if ( not isReady ) then return; end -- Make sure we're ready for a connection
	triggerClientEvent ( source, "ModLoader:OnServerReadyAccepts", source );
end );