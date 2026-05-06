local ev_template = {}

local INGREDIENT_TO_OUTPUT = {
  VIVICHOKE = "PP_UP",
  QUALOT_BERRY = "IRON",
  GREPA_BERRY = "ZINC",
  KELPSY_BERRY = "PROTEIN",
  POMEG_BERRY = "HP_UP",
  HONDEW_BERRY = "CALCIUM",
  TAMATO_BERRY = "CARBOS",
}

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

local NOT_ENOUGH = -1

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

  if brewing_stand.list()[5] == nil then
    blaze_powder_container.pushItems(peripheral.getName(brewing_stand), blaze_powder_available_slot, 1, TARGET_SLOT.BLAZE_POWER)
    print("transferred 1 blaze powder")
  end
end

---@param potion_container ccTweaked.peripheral.wrappedPeripheral
---@param brewing_stand ccTweaked.peripheral.wrappedPeripheral
local function place_potion(potion_container, brewing_stand, potion_name)
  local potion_count = 0
  for i = 1, 3 do
    local available_slot = get_last_available_slot(potion_container)
    if available_slot == -1 then
      break
    end

    potion_container.pushItems(peripheral.getName(brewing_stand), available_slot, 1, TARGET_SLOT.POTION_ONE + i - 1)
    potion_count = potion_count + 1
  end

  print("transferred " .. potion_count .. " " .. potion_name)
  return potion_count
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

---@param container ccTweaked.peripheral.wrappedPeripheral
---@return string
local function get_item_name_first_slot(container)
  local item = container.list()[1].name
  local colon_index = item:find(":") + 1
  local item_name = item:sub(colon_index):upper()
  return item_name
end

function ev_template.make()
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
    local is_potion_ready = get_last_available_slot(potion_container)
    local is_ingredient_ready = get_last_available_slot(ingredient_container)
    local is_blaze_powder_ready = is_blaze_powder_sufficient(brewing_stand, blaze_powder_container)

    if is_potion_ready == NOT_ENOUGH then
      print("error: not enough in potion container!")
    end

    if is_ingredient_ready == NOT_ENOUGH then
      print("error: not enough in ingredient container!")
    end

    if not is_blaze_powder_ready then
      print("error: not enough blaze powder container!")
    end

    if is_potion_ready ~= NOT_ENOUGH and is_ingredient_ready ~= NOT_ENOUGH and is_blaze_powder_ready then
      local ingredient_name = get_item_name_first_slot(ingredient_container)
      local potion_name = get_item_name_first_slot(potion_container)
      local output_name = INGREDIENT_TO_OUTPUT[ingredient_name]

      place_blaze_powder(brewing_stand, blaze_powder_container)

      place_ingredient(ingredient_container, brewing_stand, ingredient_name)
      local potions_count = place_potion(potion_container, brewing_stand, potion_name)

      print("waiting...")
      sleep(20)

      place_output(potions_count, output_name)
    else
      print("diagnostic: please restock necessary ingredients")
      print("diagnostic: restarting process soon")
      sleep(4)
    end
    print("restarting process...")
    sleep(1)
    shell.run("clear")
  end
end

return ev_template
