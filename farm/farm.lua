local helpers = require("helpers")

local FUEL_REQUIREMENT = 100
local POLLING_TIME = 600

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
    print("harvesting...")
    main_helper()
    print("farm is not ready to harvest")

    print("resting...")
    sleep(300)
  end
end

main()
