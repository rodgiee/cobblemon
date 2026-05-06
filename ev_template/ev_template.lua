local ev_template = {}

---@alias VITAMIN table<string, table<string, string>>
---@type VITAMIN
local VITAMIN = {
  PP_UP = {
    INGREDIENT = "Vivichoke",
    POTION = "Medicinal Brew",
    OUTPUT = "PP Up",
  },
  IRON = {
    INGREDIENT = "Qualot Berry",
    POTION = "PP Up",
    OUTPUT = "Iron",
  },
  ZINC = {
    INGREDIENT = "Grepa Berry",
    POTION = "PP Up",
    OUTPUT = "Zinc",
  },
  PROTEIN = {
    INGREDIENT = "Kelpsy Berry",
    POTION = "PP Up",
    OUTPUT = "Protein",
  },
  HP_UP = {
    INGREDIENT = "Pomeg Berry",
    POTION = "PP Up",
    OUTPUT = "HP Up",
  },
  CALCIUM = {
    INGREDIENT = "Hondew Berry",
    POTION = "PP Up",
    OUTPUT = "Calcium",
  },
  CARBOS = {
    INGREDIENT = "Tamato Berry",
    POTION = "PP Up",
    OUTPUT = "Carbos",
  },
}

local ev_type = {}

local TARGET_SLOT = {
  POTION_ONE = 1,
  POTION_TWO = 2,
  POTION_THREE = 3,
  INGREDIENT = 4,
  BLAZE_POWER = 5,
}

local SOURCE_SLOT = {
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

---@param ingredient_container ccTweaked.peripheral.wrappedPeripheral
---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
local function place_ingredient(ingredient_container, brewing_stand, ingredient_name)
  local available_slot = get_last_available_slot(ingredient_container)

  if available_slot == -1 then
    error("error: ran out of " .. ingredient_name)
  end

  ingredient_container.pushItems(peripheral.getName(brewing_stand), available_slot, 1, TARGET_SLOT.INGREDIENT)
  print("transferred 1 " .. ingredient_name)
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

  print("transferred " .. iterations .. " " .. potion_name)
  return iterations
end

---@param potion_count integer
---@param output_name string
local function place_output(potion_count, output_name)
  turtle.select(SOURCE_SLOT.BREW)
  for i = 1, potion_count do
    turtle.suck()
  end

  turtle.dropUp()
  print("outputted " .. potion_count .. " " .. output_name .. "!")
end

---@param container ccTweaked.peripheral.wrappedPeripheral
---@param required_amount integer
---@return boolean
local function is_ingredient_sufficient(container, required_amount)
  local available_slot = get_last_available_slot(container)

  if available_slot == -1 then
    return false
  end

  -- if current slot does not have enough items but the next slot does count the next
  local count = container.list()[available_slot].count
  local carry = container.list()[available_slot - 1]

  if carry ~= nil then
    count = count + carry.count
  end

  if count >= required_amount then
    return true
  end

  return false
end

---@param container ccTweaked.peripheral.wrappedPeripheral
---@return boolean
local function is_blaze_powder_sufficient(brewing_stand, container)
  local brewing_stand_blaze_powder_slot = brewing_stand.list()[5]

  if brewing_stand_blaze_powder_slot ~= nil then
    return true
  end

  local available_slot = get_last_available_slot(container)

  if available_slot ~= -1 then
    return true
  end

  return false
end

---@param vitamin string
function ev_template.make_vitamin(vitamin)
  if VITAMIN[vitamin] == nil then
    error('error: vitamin "' .. vitamin .. '" is not valid')
  end
  local ingredient_name = VITAMIN[vitamin].INGREDIENT
  local potion_name = VITAMIN[vitamin].POTION
  local output_name = VITAMIN[vitamin].OUTPUT

  while true do
    local potion_container = peripheral.wrap("left")
    local ingredient_container = peripheral.wrap("back")
    local blaze_powder_container = peripheral.wrap("right")
    local output_container = peripheral.wrap("top")
    local brewing_stand = peripheral.wrap("front")

    if potion_container == nil then
      error("error: missing potion_container")
    end

    if ingredient_container == nil then
      error("error: missing ingredient_container")
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

    -- check if enough ingredients
    local is_potion_ready = is_ingredient_sufficient(potion_container, 3)
    local is_ingredient_ready = is_ingredient_sufficient(ingredient_container, 1)
    local is_blaze_powder_ready = is_blaze_powder_sufficient(brewing_stand, blaze_powder_container)

    if not is_potion_ready then
      print("error: not enough " .. { potion_name } .. "!")
    end

    if not is_ingredient_ready then
      print("error: not enough " .. { ingredient_name } .. "!")
    end

    if not is_blaze_powder_ready then
      print("error: not enough blaze powder!")
    end

    place_blaze_powder(brewing_stand, blaze_powder_container)

    place_ingredient(ingredient_container, brewing_stand, ingredient_name)

    local potions_count = place_potion(potion_container, brewing_stand, potion_name)

    print("waiting...")
    sleep(20)

    place_output(potions_count, output_name)
  end
end

return ev_template
