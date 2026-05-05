local TARGET_SLOT = {
  POTION_ONE = 1,
  POTION_TWO = 2,
  POTION_THREE = 3,
  INGREDIENT = 4,
  BLAZE_POWER = 5,
}

---@param container ccTweaked.peripheral.wrappedPeripheral
local function get_last_available_slot(container)
  local items = container.list()
  local last_available_slot = -1
  local pointer = 1
  while items[pointer] ~= nil do
    last_available_slot = pointer
    pointer = pointer + 1
  end
  return last_available_slot
end

---@param ingredient_container ccTweaked.peripheral.wrappedPeripheral
---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
local function place_ingredient(ingredient_container, brewing_stand, ingredient_name)
  local available_slot = get_last_available_slot(ingredient_container)

  if available_slot == -1 then
    error("error: ran out of " .. ingredient_name)
  end

  ingredient_container.pushItems(peripheral.getName(brewing_stand), available_slot, 1, TARGET_SLOT.INGREDIENT)
  print("dropped 1 " .. ingredient_name)
end

---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
---@param blaze_powder_container ccTweaked.peripheral.wrappedPeripheral
local function place_blaze_powder(brewing_stand, blaze_powder_container)
  local blaze_powder_available_slot = get_last_available_slot(blaze_powder_container)

  if blaze_powder_available_slot == -1 then
    error("error: ran out of blaze powder!")
  end
  if brewing_stand.list()[5] == nil then
    blaze_powder_container.pushItems(peripheral.getName(brewing_stand), blaze_powder_available_slot, 1, TARGET_SLOT.BLAZE_POWER)
    print("placed 1 blaze powder")
  end
end

---@param potion_container ccTweaked.peripheral.wrappedPeripheral
---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
local function place_potion(potion_container, brewing_stand, potion_name)
  local available_slot = get_last_available_slot(potion_container)

  if available_slot == -1 then
    error("error: ran out of " .. potion_name)
  end
  local slot_total = potion_container.list()[available_slot].count
  local iterations = math.min(slot_total, 3)

  for i = 1, iterations do
    potion_container.pushItems(peripheral.getName(brewing_stand), available_slot, 1, TARGET_SLOT.POTION_ONE + i - 1)
  end

  print("dropped " .. iterations .. " " .. potion_name)
end

local function main()
  local medicinal_brew_container = peripheral.wrap("left")
  local vivichoke_container = peripheral.wrap("back")
  local blaze_powder_container = peripheral.wrap("right")
  local output_container = peripheral.wrap("top")
  local brewing_stand = peripheral.wrap("front")

  if medicinal_brew_container == nil then
    error("error: missing medicinal_brew_container")
  end

  if vivichoke_container == nil then
    error("error: missing vivichoke_container")
  end

  if blaze_powder_container == nil then
    error("error: missing blaze_powder_container")
  end

  if output_container == nil then
    error("error: missing output_container")
  end

  if brewing_stand == nil then
    error("error: missing brewing_stand")
  end

  place_blaze_powder(brewing_stand, blaze_powder_container)

  place_ingredient(vivichoke_container, brewing_stand, "vivichoke")

  place_potion(medicinal_brew_container, brewing_stand, "medicinal brew")
end

main()
