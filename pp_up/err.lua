local err = {}

---@param container ccTweaked.peripheral.wrappedPeripheral|nil
---@param container_name string
function err.check_container(container, container_name)
  if container == nil then
    error("error: missing" .. container_name .. " container")
  end
end

return err
