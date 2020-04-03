-- Basic setup, variables to use. (Might expose to settings sometime? Or perhaps make research allow for longer wall segments?)

local horz_wall, vert_wall = 1, 2
local dir_mods = {{1,0,horz_wall},{-1,0,horz_wall},{0,1,vert_wall},{0,-1,vert_wall}}

local kw_per_tick = 100
local kj_to_fill = 5000
local wall_health = 10000

local joules_per_hitpoint = 400
local node_range = 16

-- Functions translplanted + renamed to clarify

function CnC_SonicWall_FindNodes(surf, pos, force, dir)
    local near_nodes = {nil, nil, nil, nil}
    local near_dists = {999, 999, 999, 999}
    for k,v in pairs(global.hexi_hardlight_nodes) do
        if not force or force.name == v.force.name then
            local that_surf = v.surface
            if surf.index == that_surf.index then
                local that_pos = v.position
                if pos.x == that_pos.x and pos.y ~= that_pos.y then
                    if dir == vert_wall or dir == horz_wall + vert_wall then
                        local diff = that_pos.y - pos.y
                        if math.abs(diff) <= node_range then
                            local sy, ty
                            if diff < 0 then
                                if -diff < near_dists[1] then
                                    near_nodes[1] = v
                                    near_dists[1] = -diff
                                end
                            else
                                if diff < near_dists[2] then
                                    near_nodes[2] = v
                                    near_dists[2] = diff
                                end
                            end
                        end
                    end
                elseif pos.x ~= that_pos.x and pos.y == that_pos.y then
                    if dir == horz_wall or dir == horz_wall + vert_wall then
                        local diff = that_pos.x - pos.x
                        if math.abs(diff) <= node_range then
                            local sx, tx
                            if diff < 0 then
                                if -diff < near_dists[3] then
                                    near_nodes[3] = v
                                    near_dists[3] = -diff
                                end
                            else
                                if diff < near_dists[4] then
                                    near_nodes[4] = v
                                    near_dists[4] = diff
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    local nodes = {}
    if near_nodes[1] ~= nil then nodes[#nodes+1] = near_nodes[1] end
    if near_nodes[2] ~= nil then nodes[#nodes+1] = near_nodes[2] end
    if near_nodes[3] ~= nil then nodes[#nodes+1] = near_nodes[3] end
    if near_nodes[4] ~= nil then nodes[#nodes+1] = near_nodes[4] end
    return nodes
end

function CnC_SonicWall_AddNode(entity, tick)
    global.hexi_hardlight_nodes[#global.hexi_hardlight_nodes+1] = entity
    global.hexi_hardlight_node_ticklist[#global.hexi_hardlight_node_ticklist+1] = {entity, tick + math.ceil(kj_to_fill / kw_per_tick)}
end

function CnC_SonicWall_DisableNode(entity)
    local surf = entity.surface
    local pos = {x=math.floor(entity.position.x),y=math.floor(entity.position.y)}
    
    for k,v in pairs(dir_mods) do
        local tx = pos.x + v[1]
        local ty = pos.y + v[2]
        while global.hexi_hardlight_segments[surf.index] and global.hexi_hardlight_segments[surf.index][tx] and global.hexi_hardlight_segments[surf.index][tx][ty] do
            local wall = global.hexi_hardlight_segments[surf.index][tx][ty]
            if wall[1] == v[3] then
                global.hexi_hardlight_segments[surf.index][tx][ty][2].destroy()
                global.hexi_hardlight_segments[surf.index][tx][ty] = nil
            elseif wall[1] == horz_wall + vert_wall then
                global.hexi_hardlight_segments[surf.index][tx][ty][1] = horz_wall + vert_wall - v[3]
                global.hexi_hardlight_segments[surf.index][tx][ty][2].graphics_variation = horz_wall + vert_wall - v[3]
            end
            tx = tx + v[1]
            ty = ty + v[2]
        end
    end
end

function CnC_SonicWall_DeleteNode(entity)
    CnC_SonicWall_DisableNode(entity)
    for k,v in pairs(global.hexi_hardlight_nodes) do
        if v == entity then
            table.remove(global.hexi_hardlight_nodes, k)
            break
        end
    end
    for k,v in pairs(global.hexi_hardlight_node_ticklist) do
        if v[1] == entity then
            table.remove(global.hexi_hardlight_node_ticklist, k)
            break
        end
    end
end

function CnC_SonicWall_WallDamage(surf, pos, tick)
    if global.hexi_hardlight_segments[surf.index] and global.hexi_hardlight_segments[surf.index][math.floor(pos.x)] and global.hexi_hardlight_segments[surf.index][math.floor(pos.x)][math.floor(pos.y)] then
        local mark_death = false
        local force = nil
        
        local wall = global.hexi_hardlight_segments[surf.index][math.floor(pos.x)][math.floor(pos.y)]
        local damage_amt = wall_health - wall[2].health
        wall[2].health = wall_health
        local joule_cost = damage_amt * joules_per_hitpoint
        
        local connected_nodes = CnC_SonicWall_FindNodes(surf, pos, nil, wall[1], true)
        local shared_cost = joule_cost / #connected_nodes
        for k,v in pairs(connected_nodes) do
            if not force then force = v.force end
            local energy = v.energy - shared_cost * joules_per_hitpoint
            if energy < 0 then energy = 0 end
            v.energy = energy
            
            if energy == 0 then
                if not mark_death then
                    CnC_SonicWall_SendAlert(v.force, defines.alert_type.entity_destroyed, wall[2])
                    mark_death = true
                end
                CnC_SonicWall_DisableNode(v)
                global.hexi_hardlight_node_ticklist[#global.hexi_hardlight_node_ticklist+1] = {v, tick + math.ceil(kj_to_fill / kw_per_tick)}
            end
        end
        if not mark_death then
            CnC_SonicWall_SendAlert(force, defines.alert_type.entity_under_attack, wall[2])
        end
    end
end

function CnC_SonicWall_SendAlert(force, alert_type, entity)
    for k,v in pairs(force.players) do
        v.add_alert(entity, alert_type)
    end
end

function CnC_SonicWall_TestWall(surf, pos, dir, node)
    if not global.hexi_hardlight_segments[surf.index] then global.hexi_hardlight_segments[surf.index] = {} end
    if not global.hexi_hardlight_segments[surf.index][math.floor(pos[1])] then global.hexi_hardlight_segments[surf.index][math.floor(pos[1])] = {} end
    
    if not global.hexi_hardlight_segments[surf.index][math.floor(pos[1])][math.floor(pos[2])] then
        if not surf.can_place_entity{name="CnC_SonicWall_Wall", position=pos, force=node.force} then return false end
    else
        local wall = global.hexi_hardlight_segments[surf.index][math.floor(pos[1])][math.floor(pos[2])]
        if wall[1] ~= horz_wall + vert_wall - dir then return false end
    end
    
    return true
end

function CnC_SonicWall_MakeWall(surf, pos, dir, node)
    if not global.hexi_hardlight_segments[surf.index] then global.hexi_hardlight_segments[surf.index] = {} end
    if not global.hexi_hardlight_segments[surf.index][math.floor(pos[1])] then global.hexi_hardlight_segments[surf.index][math.floor(pos[1])] = {} end
    
    if not global.hexi_hardlight_segments[surf.index][math.floor(pos[1])][math.floor(pos[2])] then
        local wall = surf.create_entity{name="CnC_SonicWall_Wall", position=pos, force=node.force}
        if not wall then error("Wall creation failed!") end
        wall.graphics_variation = dir
        global.hexi_hardlight_segments[surf.index][math.floor(pos[1])][math.floor(pos[2])] = {dir, wall}
    else
        local wall = global.hexi_hardlight_segments[surf.index][math.floor(pos[1])][math.floor(pos[2])]
        if wall[1] == horz_wall + vert_wall - dir then wall[1] = horz_wall + vert_wall end
        wall[2].graphics_variation = horz_wall + vert_wall
    end
end

function tryCnC_SonicWall_MakeWall(node1, node2)
    local that_pos = node2.position
    
    if node1.position.x == that_pos.x and node1.position.y ~= that_pos.y then
        local diff = that_pos.y - node1.position.y
        if math.abs(diff) <= node_range and math.abs(diff) > 1 then
            local sy, ty
            if diff < 0 then
                sy, ty = that_pos.y+1, node1.position.y-1
            else
                sy, ty = node1.position.y+1, that_pos.y-1
            end
            
            for y=sy,ty do
                if not CnC_SonicWall_TestWall(node1.surface, {node1.position.x,y}, vert_wall, node1) then return end
            end
            for y=sy,ty do
                CnC_SonicWall_MakeWall(node1.surface, {node1.position.x,y}, vert_wall, node1)
            end
        end
    elseif node1.position.x ~= that_pos.x and node1.position.y == that_pos.y then
        local diff = that_pos.x - node1.position.x
        if math.abs(diff) <= node_range and math.abs(diff) > 1 then
            local sx, tx
            if diff < 0 then
                sx, tx = that_pos.x+1, node1.position.x-1
            else
                sx, tx = node1.position.x+1, that_pos.x-1
            end
            
            for x=sx,tx do
                if not CnC_SonicWall_TestWall(node1.surface, {x,node1.position.y}, horz_wall, node1) then return end
            end
            for x=sx,tx do
                CnC_SonicWall_MakeWall(node1.surface, {x,node1.position.y}, horz_wall, node1)
            end
        end
    end
end

-- That's the end of the functions.
-- Below are things that used to be called in scripts, moved over here to clean things up
-- OnTick used to be in script.on_event(defines.events.on_tick, function(event), for example.

function CnC_SonicWall_OnTick(event)
    local cur_tick = event.tick
	
	
    
    while #global.hexi_hardlight_damage > 0 do
        CnC_SonicWall_WallDamage(global.hexi_hardlight_damage[1][1], global.hexi_hardlight_damage[1][2], event.tick)
        table.remove(global.hexi_hardlight_damage, 1)
    end
    
    for i=#global.hexi_hardlight_node_ticklist,1,-1 do
        local cur = global.hexi_hardlight_node_ticklist[i]
        if cur[2] <= cur_tick then
            local charge_rem = kj_to_fill - (cur[1].energy / 1000)
            if charge_rem <= 0 then
                local connected_nodes = CnC_SonicWall_FindNodes(cur[1].surface, cur[1].position, cur[1].force, horz_wall + vert_wall)
                for k,v in pairs(connected_nodes) do
                    if (v.energy / 1000) >= kj_to_fill then
                        tryCnC_SonicWall_MakeWall(cur[1], v)
                    end
                end
                table.remove(global.hexi_hardlight_node_ticklist, i)
            else cur[2] = cur_tick + math.ceil(charge_rem / kw_per_tick) end
        end
    end
end

function CnC_SonicWall_OnTriggerCreatedEntity(event)
	if event.entity.name == "CnC_SonicWall_Wall-damage" then
        global.hexi_hardlight_damage[#global.hexi_hardlight_damage+1] = {event.entity.surface, event.entity.position}
        event.entity.destroy()
    end
end

function CnC_SonicWall_OnInit(event)
	global.hexi_hardlight_nodes = {}
    global.hexi_hardlight_node_ticklist = {}
    global.hexi_hardlight_segments = {}
    global.hexi_hardlight_damage = {}
end









