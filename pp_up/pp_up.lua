local TARGET_SLOT = {
  POTION_ONE = 1,
  POTION_TWO = 2,
  POTION_THREE = 3,
  INGREDIENT = 4,
  BLAZE_POWER = 5,
}

local SOURCE_SLOT = {
  POTION_ONE = 2,
  POTION_TWO = 3,
  POTION_THREE = 4,
  GLASS_BOTTLE = 1,
  BREW = 5,
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

local function place_medicinal_leek(leek_container, brewing_stand)
  if leek_container.pushItems(peripheral.getName(brewing_stand), 1, 1, TARGET_SLOT.INGREDIENT) == 0 then
    error("error: ran out of medicinal leeks!")
  end
  print("dropped 1 medicinal leek")
end

---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
---@param blaze_powder_container ccTweaked.peripheral.wrappedPeripheral
local function place_blaze_powder(brewing_stand, blaze_powder_container)
  get_last_available_slot()
  if brewing_stand.list()[5] == nil then
    if blaze_powder_container.pushItems(peripheral.getName(brewing_stand), 1, 1, TARGET_SLOT.BLAZE_POWER) == 0 then
      error("error: ran out of blaze powder!")
    end
    print("placed 1 blaze powder")
  end
end

local function get_potion_count(count)
  if turtle.getItemCount(SOURCE_SLOT.GLASS_BOTTLE) == 0 then
    error("error: ran out of glass bottles")
  end
  turtle.select(SOURCE_SLOT.GLASS_BOTTLE)

  local potions_count = 3
  if count == 3 then
    potions_count = 2
  elseif count == 2 then
    potions_count = 1
  elseif count <= 1 then
    error("error: not enough glass bottles")
  end
  return potions_count
end

local function main()
  while true do
    local brewing_stand = peripheral.wrap("front")
    local leek_container = peripheral.wrap("left")
    local blaze_powder_container = peripheral.wrap("right")
    local output_container = peripheral.wrap("top")

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

    place_blaze_powder(brewing_stand, blaze_powder_container)

    place_medicinal_leek(leek_container, brewing_stand)

    local count = turtle.getItemCount(SOURCE_SLOT.GLASS_BOTTLE)
    local potions_count = get_potion_count(count)

    for i = 1, potions_count do
      turtle.placeDown()
    end
    print("filled " .. potions_count .. " potions")

    for position = SOURCE_SLOT.POTION_ONE, SOURCE_SLOT.POTION_ONE + potions_count - 1 do
      turtle.select(position)
      turtle.drop()
    end
    print("transferred " .. potions_count .. " potions")

    print("waiting...")
    sleep(20)

    turtle.select(SOURCE_SLOT.BREW)
    for i = 1, potions_count do
      turtle.suck()
    end

    turtle.dropUp()
    print("outputted " .. potions_count .. " medicinal brews!")
  end
end

main()
