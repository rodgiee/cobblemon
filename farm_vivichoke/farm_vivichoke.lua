local helpers = require("helpers")

local FUEL_REQUIREMENT = 100

local function main_helper()
  local is_fuel_ready = helpers.is_enough_fuel(FUEL_REQUIREMENT)
  local got_fuel = true
  if is_fuel_ready == false then
    got_fuel = helpers.get_fuel()
  end

  if got_fuel == false then
    error("error: not enough fuel!")
  end

  -- Harvest farm
  helpers.traverse_farm(9)

  helpers.deposit()
end

local function main()
  while true do
    -- check if there is enough fuel, if not then restock
    local is_ready_to_harvest = helpers.scan_ready()

    if is_ready_to_harvest then
      print("harvesting!")
      main_helper()
    else
      print("farm is not ready to harvest")
    end

    print("resting...")
    sleep(120)
  end
end

main()
