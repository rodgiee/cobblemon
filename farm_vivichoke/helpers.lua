local helpers = {}

local TURTLE_SLOT = {
  YIELD_ONE = 1,
  SEED_ONE = 2,
  YIELD_TWO = 5,
  SEED_TWO = 6,
}

local POSITON = {
  FAR_SIDE = 1,
  NEAR_SIDE = 0,
}

local READY_TO_HARVEST = 7

---@return boolean
function helpers.scan_ready()
  local is_block, inspection = turtle.inspect()

  if is_block == false then
    error("error: no crop in front!")
  end

  local age = inspection.state.age
  if age == READY_TO_HARVEST then
    return true
  end

  return false
end

function helpers.get_fuel()
  turtle.turnRight()
  local is_picked = turtle.suck()
  turtle.refuel()
  turtle.turnLeft()

  return is_picked
end

---@param requirement integer
---@return boolean
function helpers.is_enough_fuel(requirement)
  local current_fuel = turtle.getFuelLevel()
  if current_fuel < requirement then
    return false
  end
  return true
end

-- deposit yield and seeds
function helpers.deposit()
  turtle.turnLeft()
  for key, slot in pairs(TURTLE_SLOT) do
    turtle.select(slot)
    turtle.drop()
  end
  turtle.turnRight()
end

-- check if crop is ready, if so then harvest and replant
function helpers.harvest()
  local inspection, details = turtle.inspectDown()

  if inspection == false then
    return
  end

  -- get age
  local age = details.state.age
  local slot_one_count = turtle.getItemCount(TURTLE_SLOT.YIELD_ONE)
  local seed_slot = -1

  if slot_one_count == 64 then
    turtle.select(TURTLE_SLOT.YIELD_TWO)
    seed_slot = TURTLE_SLOT.SEED_TWO
  else
    turtle.select(TURTLE_SLOT.YIELD_ONE)
    seed_slot = TURTLE_SLOT.SEED_ONE
  end

  if age == READY_TO_HARVEST then
    turtle.digDown()
    turtle.select(seed_slot)
    turtle.placeDown()
  end
end

-- traverse the standard 9x9 farm, harvest at each block
-- turtle consumes 100 fuel for traversal
function helpers.traverse_farm(grid_length)
  local blocks_traversed = 0
  local grid_size = grid_length * grid_length

  turtle.up()

  -- traverse farm
  -- odd = turn left
  -- even = turn right
  for i = 1, grid_size do
    if blocks_traversed % grid_length == 0 and blocks_traversed ~= 0 then
      local turtle_positon = blocks_traversed % 2
      if turtle_positon == POSITON.FAR_SIDE then
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
      else
        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()
      end
    else
      turtle.forward()
    end
    helpers.harvest()
    blocks_traversed = blocks_traversed + 1
  end

  -- send turtle back home
  turtle.turnRight()
  for i = 1, 8 do
    turtle.forward()
  end

  turtle.turnRight()
  for i = 1, 9 do
    turtle.forward()
  end

  turtle.turnRight()
  turtle.turnRight()

  turtle.down()
end

return helpers
