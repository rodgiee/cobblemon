local Phase = {
  EMPTY = "empty",
  BREW = "brew",
  PP_UP = "pp_up",
}

local Target_Slot = {
  POTION_ONE = 1,
  POTION_TWO = 2,
  POTION_THREE = 3,
  INGREDIENT = 4,
  BLAZE_POWER = 5,
}

local Source_Slot = {
  POTION_ONE = 2,
  POTION_TWO = 3,
  POTION_THREE = 4,
  GLASS_BOTTLE = 1,
  BREW = 5,
}

---@param table table
local function is_empty(table)
  return next(table) == nil
end

---@param inspection ccTweaked.peripheral.itemList list
local function check_phase(inspection)
  local phase = ""

  if inspection[Target_Slot.POTION_ONE] == nil then
    phase = Phase.EMPTY
  end

  return phase
end

local err = require("err")

local function main()
  local brewing_stand = peripheral.wrap("front")
  local leek_container = peripheral.wrap("left")
  local blaze_powder_container = peripheral.wrap("right")
  local output_container = peripheral.wrap("back")

  if output_container == nil then
    error("error: missing output_container barrel")
  end

  if blaze_powder_container == nil then
    error("error: missing blaze_powder_container barrel")
  end

  if brewing_stand == nil then
    error("error: missing brewing stand")
  end

  if leek_container == nil then
    error("error: missing leek_container barrel")
  end
  local phase = check_phase(brewing_stand.list())

  if phase == Phase.EMPTY then
    if brewing_stand.list()[5] == nil then
      if blaze_powder_container.pushItems(peripheral.getName(brewing_stand), 1, 1, Target_Slot.BLAZE_POWER) == 0 then
        error("error: ran out of blaze powder!")
      end
      print("placed 1 blaze powder")
    end

    if leek_container.pushItems(peripheral.getName(brewing_stand), 1, 1, Target_Slot.INGREDIENT) == 0 then
      error("error: ran out of medicinal leeks!")
    end
    print("dropped 1 medicinal leek")

    if turtle.getItemCount(Source_Slot.GLASS_BOTTLE) == 0 then
      error("error: ran out of glass bottles!")
    end
    turtle.select(Source_Slot.GLASS_BOTTLE)

    local potions_count = ((turtle.getItemCount(Source_Slot.GLASS_BOTTLE) - 1) % 3) + 1

    for i = 1, potions_count do
      turtle.placeDown()
    end
    print("filled " .. potions_count .. " potions")

    for position = Source_Slot.POTION_ONE, Source_Slot.POTION_ONE + potions_count - 1 do
      turtle.select(position)
      turtle.drop()
    end
    print("transferred " .. potions_count .. " potions")
    if 1 == 1 then
      return
    end
    turtle.select(Source_Slot.POTION_ONE)
    turtle.drop()
    turtle.select(Source_Slot.POTION_TWO)
    turtle.drop()
    turtle.select(Source_Slot.POTION_THREE)
    turtle.drop()

    print("waiting...")
    sleep(20)

    turtle.select(Source_Slot.BREW)
    parallel.waitForAll(function()
      turtle.suck()
    end, function()
      turtle.suck()
    end, function()
      turtle.suck()
    end)
    print("retrieved 3 medicinal brews")
  end
end

main()
