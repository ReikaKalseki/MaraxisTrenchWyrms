--TODO: remove move this and use DI

require "constants"

require "util"
require("sound-util")

function merge(old, new)
	old = table.deepcopy(old)

	for k, v in pairs(new) do
		if v == "nil" then
			old[k] = nil
		else
			old[k] = v
		end
	end

	return old
end

function addDerivativeFull(template, overrides)
	local merged = merge(template, overrides)
	data:extend({merged})
end

function addDerivative(type, name, overrides)
	if not data.raw[type] then error("No such prototype type '" .. type .. "' to add a derivative of '" .. name .. "'!") end
	addDerivativeFull(data.raw[type][name], overrides)
end

-------------------------------------------------------------

table.insert(data.raw.recipe["maraxsis-wyrm-confinement-cell"].ingredients, {type = "item", name = "maraxsis-fish-food", amount = 1})
data.raw.recipe["maraxsis-wyrm-specimen"].hidden = true
data.raw.technology["hydraulic-science-pack"].research_trigger = {
        type = "scripted",
        trigger_description = "scripted-trigger.capture-wyrm-egg"
}
	
local function spawnersprite(var)
local ret = {
  file_count = 1,
  height = 166,
  width = 166,
  line_length = 1,
  lines_per_file = 1,
  name = "wyrmspawner",
  sprite_count = 1,
  shift = {x = 0 / 32, y = 0 / 32},
  x = 254*var,

    filename = "__MaraxisTrenchWyrms__/graphics/entity/wyrm-spawner.png",
   direction_count = 1,
    frame_count = 1,
    scale = 1,
    apply_projection = true,
    flags = {"no-scale"},
}
--[[
	ret = {
        layers = {
            ret,
            table.deepcopy(ret),
        }
    }
    ret.layers[2].filename = "__MaraxisTrenchWyrms__/graphics/entity/spawner-glow.png"
    ret.layers[2].draw_as_light = true
	--]]
	return ret
end

--[[
addDerivative("turret", "big-worm-turret", 
  {
    name = "wyrm-spawner",
    --icon = "__base__/graphics/icons/big-worm.png",
    max_health = 1500,
	destructible = false,
    resistances =
    {
      {
        type = "physical",
        percent = 100
      },
      {
        type = "explosion",
        percent = 100
      },
      {
        type = "fire",
        percent = 100
      },
      {
        type = "laser",
        percent = 100
      },
      {
        type = "impact",
        percent = 100
      }
    },
    collision_box = {{-1.4, -1.2}, {1.4, 1.2}},
    map_generator_bounding_box = {{-2.4, -2.2}, {2.4, 2.2}},
    selection_box = {{-1.4, -1.2}, {1.4, 1.2}},
    shooting_cursor_size = 4,
	
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "wyrm",
      cooldown = 300,
      projectile_creation_distance = 1,
      projectile_center = {0, 0},
      min_range = 0,
      range = 80,
	  ammo_type = {
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = { --target_effects would place it at the target
					type = "create-entity",
					entity_name = "wyrm-aggressive",
					trigger_created_entity = true,
					as_enemy = true,
					ignore_no_enemies_mode = true,
				}
			}
		},
		target_type = "entity",
	  }
    },
	
    damaged_trigger_effect = "nil",
    dying_sound = "nil",
	
    rotation_speed = 1,
    graphics_set = {},
    folded_speed = 0.01,
    folded_speed_secondary = 0.024,
    folded_animation_is_stateless = true,
    folded_animation = spawnersprite,
    preparing_speed = 0.024,
    preparing_animation = "nil",
    preparing_sound = "nil",
    prepared_speed = 0.024,
    prepared_speed_secondary = 0.012,
    prepared_animation = spawnersprite,
    prepared_sound = "nil",
    prepared_alternative_speed = 0.014,
    prepared_alternative_speed_secondary = 0.010,
    prepared_alternative_chance = 0.2,
    prepared_alternative_animation = "nil",
    prepared_alternative_sound = "nil",
    starting_attack_speed = 0.034,
    starting_attack_animation = "nil",
    starting_attack_sound = "nil",
    ending_attack_speed = 0.016,
    ending_attack_animation = "nil",
    folding_speed = 0.015,
    folding_animation =  "nil",
    folding_sound = "nil",
    integration = "nil",
    random_animation_offset = true,
    attack_from_start_frame = true,

    prepare_range = 200,
    allow_turning_when_starting_attack = true,
    build_base_evolution_requirement = 0.99,
    autoplace = "nil",
    spawn_decorations_on_expansion = true,
    spawn_decoration = "nil",
  }
)
--]]
--error(serpent.block(data.raw.turret["wyrm-spawner"]))

addDerivative("unit-spawner", "biter-spawner", 
  {
    name = "wyrm-spawner",
    --icon = "__base__/graphics/icons/big-worm.png",
    max_health = 1500,
	destructible = false,
	selectable_in_game = false,
    resistances =
    {
      {
        type = "physical",
        percent = 100
      },
      {
        type = "explosion",
        percent = 100
      },
      {
        type = "fire",
        percent = 100
      },
      {
        type = "poison",
        percent = 100
      },
      {
        type = "acid",
        percent = 100
      },
      {
        type = "electric",
        percent = 100
      },
      {
        type = "laser",
        percent = 100
      },
      {
        type = "impact",
        percent = 100
      }
    },
    collision_box = {{-1.4, -1.2}, {1.4, 1.2}},
    map_generator_bounding_box = {{-2.4, -2.2}, {2.4, 2.2}},
    selection_box = {{-1.4, -1.2}, {1.4, 1.2}},
	dying_sound = "nil",
	damaged_trigger_effect = "nil",
	absorptions_per_second = {},
    max_count_of_owned_units = 3,
    max_friends_around_to_spawn = 3,
    working_sound = "nil",--[[
    {
      sound = {category = "enemy", filename = "__base__/sound/creatures/spawner.ogg", volume = 0.6, modifiers = volume_multiplier("main-menu", 0.7) },
      max_sounds_per_prototype = 3
    },--]]
    graphics_set =
    {
      animations =
      {
        spawnersprite(0),
        spawnersprite(1),
        spawnersprite(2),
        spawnersprite(3),
      }
    },
    result_units =
    {
      {"wyrm-aggressive", {{0.0, 1}, {1.0, 1}}},
    },
    -- With zero evolution the spawn rate is 15 seconds, with max evolution it is 10 seconds, under default settings
    spawning_cooldown = {900*wyrmRateScalar, 600*wyrmRateScalar},
    spawning_radius = 1,
    spawning_spacing = 0,
	autoplace = "nil",
	spawn_decoration = "nil",
	captured_spawner_entity = "nil",
	
  }
)

local v = {
--[[
  file_count = 1,
  height = 166,
  line_length = 17,
  lines_per_file = 19,
  name = "1",
  shift = {x = 0 / 32, y = 0 / 32},
  sprite_count = 320,
  width = 32,

    filename = "__MaraxisTrenchWyrms__/graphics/entity/wyrm.png",
   direction_count = 32,
    frame_count = 10,
    animation_speed = 0.4,
    scale = 1.25*2,
    apply_projection = true,
    flags = {"no-scale"},
	--]]
  file_count = 1,
  height = 166,
  width = 166,
  line_length = 32,
  lines_per_file = 1,
  name = "wyrm",
  sprite_count = 32,
  shift = {x = 0 / 32, y = 0 / 32},

    filename = "__MaraxisTrenchWyrms__/graphics/entity/base_strip.png",
   direction_count = 32,
    frame_count = 1,
    scale = 1.25*2,
    apply_projection = true,
    flags = {"no-scale"},
}
	v = {
        layers = {
            v,
            table.deepcopy(v),
            table.deepcopy(v),
        }
    }
    v.layers[2].filename = "__MaraxisTrenchWyrms__/graphics/entity/glow_strip.png"
    v.layers[2].draw_as_light = true
    v.layers[3].draw_as_shadow = true
    v.layers[3].shift.x = v.layers[3].shift.x + 3
    v.layers[3].shift.y = v.layers[3].shift.y + 3.5
	
	local eggsprite = {
			  filename = "__MaraxisTrenchWyrms__/graphics/entity/wyrm-egg.png",
			  priority = "high",
			  width = 143,
			  height = 120,
			  apply_projection = false,
			  run_mode = "forward-then-backward",
			  frame_count = 5,
			  line_length = 5,
			  shift = {0, 0},
			  scale = 0.5,
			  animation_speed = 0.1,
		  }
	eggsprite = {
        layers = {
            eggsprite,
            table.deepcopy(eggsprite),
        }
    }
    eggsprite.layers[2].filename = "__MaraxisTrenchWyrms__/graphics/entity/wyrm-egg-glow.png"
    eggsprite.layers[2].draw_as_light = true
	
local callsound = 
{
	type = "sound",
	name = "wyrm-call",
	category = "enemy",
	variations = sound_variations_with_volume_variations("__MaraxisTrenchWyrms__/sound/roar", 8, 0.5, 1)
}

addDerivative("unit", "maraxsis-tropical-fish-1", 
{
	name = "wyrm-aggressive",
	icon = "__MaraxisTrenchWyrms__/graphics/icons/wyrm.png",
	icon_size = 64,
	order = "c-w",
	flags = {"placeable-neutral", "placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air"},
    subgroup = "enemies",
	max_health = 1200*wyrmRateScalar,
    is_military_target = true,
    resistances =
    {
      {
        type = "physical",
        decrease = 2,
      },
      {
        type = "explosion",
        decrease = 10,
        percent = 20
      },
      {
        type = "laser",
        percent = math.max(20, math.min(80, 50-10*(wyrmRateScalar-1)))
      },
      {
        type = "poison",
        percent = 100
      },
      {
        type = "acid",
        percent = 100
      },
      {
        type = "fire",
        percent = 100
      },
      {
        type = "impact",
        percent = 100
      },
    },
	map_color = {1, 0, 0},
	healing_per_tick = data.raw.unit["behemoth-biter"].healing_per_tick*5,
	collision_box = {{0, 0}, {0, 0}},
	selection_box = {{-1.5, -5}, {1.5, 5}},
	autoplace = nil,
	vision_distance = 100, --game allows no larger
	movement_speed = data.raw.unit["behemoth-biter"].movement_speed * 1.5,
	distance_per_frame = data.raw.unit["behemoth-biter"].distance_per_frame,
	run_animation = v,
	working_sound = {
		sound = callsound,
		probability = 1 / (0.5 * 60), -- average pause between the sound is 0.5 seconds
		max_sounds_per_prototype = 2
	  },
	attack_parameters = {
	    type = "projectile",
	    ammo_category = "melee",
	    cooldown = 10,
	    range = 1,
		range_mode = "bounding-box-to-bounding-box",
	    ammo_type = {
			category = "melee",
			action = {
				type = "direct",
				action_delivery = {
					type = "instant",
					target_effects = {
						{
							type = "damage",
							damage = {amount = 20, type = "physical"}
						}
					},
					source_effects = {
						{
							type = "script",
							effect_id = "on-wyrm-attack"
						}
					}
				}
			}
	    },
	    animation = v,
      sound =    {
		category = "enemy",
		variations = sound_variations_with_volume_variations("__MaraxisTrenchWyrms__/sound/bite", 3, 1.0, 1.6),
		aggregation = { max_count = 1, remove = true, count_already_playing = true },
	  },
	},
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "on-spawn-wyrm",
			},
		},
	},
	dying_trigger_effect = {
		type = "create-entity",
		damage_type_filters = {whitelist = true, types = { "physical", "explosion" }},
		entity_name = "wyrm-egg",
		trigger_created_entity = true,
		tile_collision_mask = {layers = {water_tile = true}},
		as_enemy = true,
		ignore_no_enemies_mode = true,
		find_non_colliding_position = true,
		non_colliding_search_radius = 25,		
	},	
	--attack_parameters = data.raw.unit["big-biter"].attack_parameters,
	water_reflection = data.raw.fish["fish"].water_reflection,
	distraction_cooldown = data.raw.unit["behemoth-biter"].distraction_cooldown,
	rotation_speed = data.raw.unit["behemoth-biter"].rotation_speed,
	ai_settings = {
	    destroy_when_commands_fail = false,
	    allow_try_return_to_spawner = false,
	    path_resolution_modifier = -2,
	    do_separation = false,
	},
	minable = nil
}
)

local capsule = table.deepcopy(data.raw.item["maraxsis-wyrm-confinement-cell"])
capsule.type = "ammo"
capsule.subgroup = "ammo"
capsule.ammo_type = {
      range_modifier = 2.5,
      action = {
        action_delivery = {
          source_effects = {
            entity_name = "explosion-gunshot",
            only_when_visible = true,
            type = "create-explosion",
          },--[[
          target_effects = {
            type = "create-entity"
            entity_name = "capture-robot",
            show_in_tooltip = true,
          },--]]
          target_effects =
          {
            {
              type = "damage",
              damage = {amount = 1000, type = "wyrm-cell"},
			  show_in_tooltip = false
            }
          },
          type = "instant"
        },
        type = "direct"
      },
      target_filter = { "wyrm-egg" }
}
capsule.ammo_category = "bullet"--"wyrm"
capsule.shoot_protected = true
capsule.reload_time = 60
	
data.raw.item["maraxsis-wyrm-confinement-cell"] = nil

data:extend({
  {
    type = "ammo-category",
    name = "wyrm",
	icon = "__MaraxisTrenchWyrms__/graphics/icons/wyrm.png",
    subgroup = "ammo-category"
  },
  {
    type = "damage-type",
    name = "wyrm-cell"
  },
  capsule,
  callsound,
  {
    type = "simple-entity-with-force",
    name = "wyrm-egg",
    icon = "__MaraxisTrenchWyrms__/graphics/icons/wyrm-egg.png",
	icon_size = 32,
    flags = {"placeable-enemy", "placeable-off-grid", "not-repairable", "breaths-air"},
    max_health = 100,
    resistances =
    {
      {
        type = "physical",
        percent = 100
      },
      {
        type = "explosion",
        percent = 100
      },
      {
        type = "laser",
        percent = 100
      },
      {
        type = "fire",
        percent = 100
      },
      {
        type = "impact",
        percent = 100
      },
      {
        type = "poison",
        percent = 100
      },
      {
        type = "acid",
        percent = 100
      },
      {
        type = "electric",
        percent = 100
      },
    },
    subgroup="enemies",
	collision_mask = data.raw.turret["big-worm-turret"].collision_mask,
	order = "z",
    render_layer = "object",
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1.0, -1.0}, {1.0, 1.0}},
	is_military_target = true,
    corpse = nil,--"resin-egg-corpse",
    --dying_sound = sounds.worm_dying_small(0.65),
    pictures =
    {
	 sheet = eggsprite,
    },
	created_effect = {
		type = "direct",
		action_delivery = {
			type = "instant",
			source_effects = {
				type = "script",
				effect_id = "on-place-wyrm-egg",
			},
		},
	},
	--[[
	damaged_trigger_effect = {
		type = "create-entity",
		damage_type_filters = {whitelist = true, types = { "wyrm-cell" }}
		entity_name = "wyrm-egg",
		trigger_created_entity = true,
		tile_collision_mask = {layers = {water_tile = true}},
		as_enemy = true,
		ignore_no_enemies_mode = true,
		find_non_colliding_position = true,
		non_colliding_search_radius = 12,		
	},--]]
	dying_trigger_effect = {
		type = "script",
		effect_id = "on-capture-wyrm",
		damage_type_filters = {whitelist = true, types = { "wyrm-cell" }},
	},	
	loot =
	{
	  {
		count_max = math.ceil(settings.startup["wyrm-drops-multiplier"].value),
		count_min = 1,
		item = "maraxsis-wyrm-specimen",
		probability = 1
	  }
	}
  },
})