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

local function place_medicinal_leek(leek_container, brewing_stand)
  if leek_container.pushItems(peripheral.getName(brewing_stand), 1, 1, Target_Slot.INGREDIENT) == 0 then
    error("error: ran out of medicinal leeks!")
  end
  print("dropped 1 medicinal leek")
end

local function place_blaze_powder(brewing_stand, blaze_powder_container)
  if brewing_stand.list()[5] == nil then
    if blaze_powder_container.pushItems(peripheral.getName(brewing_stand), 1, 1, Target_Slot.BLAZE_POWER) == 0 then
      error("error: ran out of blaze powder!")
    end
    print("placed 1 blaze powder")
  end
end

local function main()
  local brewing_stand = peripheral.wrap("front")
  local leek_container = peripheral.wrap("left")
  local blaze_powder_container = peripheral.wrap("right")
  local output_container = peripheral.wrap("top")

  while true do
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

    if turtle.getItemCount(Source_Slot.GLASS_BOTTLE) == 0 then
      error("error: ran out of glass bottles")
    end
    turtle.select(Source_Slot.GLASS_BOTTLE)

    local count = turtle.getItemCount(Source_Slot.GLASS_BOTTLE)
    local potions_count = 3
    if count >= 4 then
      potions_count = 3
    elseif count == 3 then
      potions_count = 2
    elseif count == 2 then
      potions_count = 1
    else
      error("error: not enough glass bottles")
    end

    for i = 1, potions_count do
      turtle.placeDown()
    end
    print("filled " .. potions_count .. " potions")

    for position = Source_Slot.POTION_ONE, Source_Slot.POTION_ONE + potions_count - 1 do
      turtle.select(position)
      turtle.drop()
    end
    print("transferred " .. potions_count .. " potions")

    print("waiting...")
    sleep(20)

    turtle.select(Source_Slot.BREW)

    for i = 1, potions_count do
      turtle.suck()
    end

    turtle.select(Source_Slot.BREW)
    turtle.dropUp()
    print("outputted " .. potions_count .. " medicinal brews!")
  end
end

main()
