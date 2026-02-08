require "__DragonIndustries__.entities"
require "__DragonIndustries__.registration"
require "__DragonIndustries__.mathhelper"
require "__DragonIndustries__.world"

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local effect_id = event.effect_id

	if effect_id == "on-wyrm-attack" and event.cause_entity and event.cause_entity.valid then
		local pos = event.cause_entity.position
		pos.x = pos.x-50+math.random()*100
		pos.y = pos.y-50+math.random()*100
		local command = {type = defines.command.go_to_location, destination = pos, distraction = defines.distraction.none, pathfind_flags = {prefer_straight_paths = true, no_break = true}}
		event.cause_entity.commandable.set_command(command)
	elseif effect_id == "on-spawn-wyrm" then
		local entity = event.source_entity
		if math.random() < 0.7 then
			entity.surface.play_sound{path = "wyrm-call", position = entity.position, override_sound_type = "enemy"}
		end
		if settings.startup["maraxsis-wyrm-quality"].value then
			local quality = entity.quality
			local orig = quality
			local maxq = getHighestQuality().level
			while quality and quality.next and quality.level < maxq and quality.next_probability > 0 do
				--game.print("Checking quality " .. quality.name .. "->" .. quality.next.name .. " chance: " .. (quality.next_probability*100) .. "%")
				if math.random() < quality.next_probability*settings.startup["maraxsis-wyrm-quality-multiplier"].value then
					quality = quality.next
				else
					break
				end
			end
			if quality and orig.level < quality.level then
				--game.print("Upgrading wyrm to quality " .. quality.name)
				respawnWithQuality(entity, quality)
			end
		end
	elseif effect_id == "on-capture-wyrm" then
		game.forces.player.script_trigger_research("hydraulic-science-pack")
	elseif effect_id == "on-place-wyrm-egg" then
		local quality = event.cause_entity.quality
		local entity = event.source_entity
		--if quality.level > 0 then game.print("Placing an egg for quality " .. quality.name .. " wyrm @ " .. entity.position.x .. "," .. entity.position.y) end
		if quality.level > entity.quality.level then
			--game.print("Replacing with quality " .. quality.name)
			--TODO: make a "respawn with quality" helper function
			entity.surface.create_entity{name=entity.name, position=entity.position, force=entity.force, quality=quality, direction = entity.direction}
			entity.destroy()
		else
			local found1 = entity.surface.count_entities_filtered{position = entity.position, radius = 20, name = entity.name}
			local found2 = entity.surface.count_entities_filtered{position = entity.position, radius = 50, name = entity.name}
			local found3 = entity.surface.count_entities_filtered{position = entity.position, radius = 100, name = entity.name}
			if found1 > 2 or found2 > 5 or found3 > 10 then
				entity.destroy()
			end
		end
	end
end)

local function tryGenerateInChunk(surface, chunk, chance) --chance -> higher is less common, 20 is default, =~1/10
	local rand = game.create_random_generator()
	local x = (chunk.left_top.x+chunk.right_bottom.x)/2
	local y = (chunk.left_top.y+chunk.right_bottom.y)/2
	local seed = createSeed(surface, x, y)
	rand.re_seed(seed)
	local pos = nil
	if rand(0, chance/settings.startup["maraxsis-wyrm-spawner-density"].value) < 2 then
		pos = surface.find_non_colliding_position_in_box("wyrm-spawner", chunk, 0.5, false)
		if pos then 
			surface.create_entity{name = "wyrm-spawner", position = pos, force = game.forces.enemy}
		end
	end
	return pos
end

script.on_event(defines.events.on_chunk_generated, function(event)
	local surface = event.surface
	if surface.valid and surface.name == "maraxsis-trench" then
		local chunk = event.area
		tryGenerateInChunk(surface, chunk, 20)
	end
end)

local CHUNK_SIZE = 32

local function regenerateTrenchSpawners(chance)
	local surface = game.surfaces["maraxsis-trench"]
	local r = 0
	for _,e in pairs(surface.find_entities_filtered{ name = "wyrm-spawner"}) do
		if e.valid then
			e.destroy()
			r = r+1
		end
	end
	
	local n = 0
	local n2 = 0
	for chunk in surface.get_chunks() do
		local x = chunk.x
		local y = chunk.y
		if surface.is_chunk_generated({x, y}) then
			local area = {
				left_top = {	
					x = x*CHUNK_SIZE,
					y = y*CHUNK_SIZE
				},
				right_bottom = {
					x = (x+1)*CHUNK_SIZE,
					y = (y+1)*CHUNK_SIZE
				}
			}
			n2 = n2+1
			if tryGenerateInChunk(surface, area, chance) then
				n = n+1
			end
		end
	end
	game.print("Genned wyrm spawners in " .. n .. "/" .. n2 .. " chunks, after deleting " .. r)
end

local ranTick = false
--[[
script.on_event(defines.events.on_tick, function(event)	
	if not ranTick then
		local surface = game.surfaces["maraxsis-trench"]

			for _,e in pairs(surface.find_entities_filtered{ name = "wyrm-spawner"}) do
				if e.valid then e.destroy() end
			end
		
		local n = 0
		local n2 = 0
		for chunk in surface.get_chunks() do
			local x = chunk.x
			local y = chunk.y
			if surface.is_chunk_generated({x, y}) then
				local area = {
					left_top = {	
						x = x*CHUNK_SIZE,
						y = y*CHUNK_SIZE
					},
					right_bottom = {
						x = (x+1)*CHUNK_SIZE,
						y = (y+1)*CHUNK_SIZE
					}
				}
				n2 = n2+1
				if tryGenerateInChunk(surface, area) then
					n = n+1
				end
			end
		end
		game.print("Retrogenned wyrm vents in " .. n .. "/" .. n2 .. " chunks")
			
		ranTick = true
	end
end)--]]

local function addCommands()
	commands.add_command("regenerateWyrms", {"cmd.regenerate-wyrms-help"}, function(event)
		regenerateTrenchSpawners(event.parameter and 20/tonumber(event.parameter) or 20)
	end)
end

addCommands()