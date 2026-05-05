---@param container ccTweaked.peripheral.wrappedPeripheral
local function get_last_available_slot(container)
  local size = container.size()
  local items = container.list()
  local last_available_slot = -1
  local pointer = 1
  while items[pointer] ~= nil do
    last_available_slot = pointer
    pointer = pointer + 1
  end
  return last_available_slot
end

local test = peripheral.wrap("left")

if test ~= nil then
  print(get_last_available_slot(test))
end
