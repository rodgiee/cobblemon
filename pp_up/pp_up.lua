local function main()
  local medicinal_brew_container = peripheral.wrap("left")
  local vivichoke_container = peripheral.wrap("back")
  local blaze_powder_container = peripheral.wrap("right")
  local output_container = peripheral.wrap("top")

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
end

main()
