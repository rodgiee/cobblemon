local function is_empty(table)
  return next(table) == nil
end

local res = peripheral.wrap("front").list()

print(is_empty(res))
