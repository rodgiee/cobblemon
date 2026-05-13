---@param ip string
local function get_files(ip)
  local result = {}

  local response = http.get(ip)

  if response == nil then
    error("error: connection is down")
  end

  local line = response.readLine()
  while line ~= nil do
    if line:find("<li>") then
      table.insert(result, line:match('"(.-)"'))
    end
    line = response.readLine()
  end
  return result
end

---@param ip string
local function update_files(ip)
  for _, f in ipairs(get_files(ip)) do
    local res = http.get(ip .. f)

    if res == nil then
      error("error: file not found")
    end

    local res_all = res.readAll()

    local file = fs.open(f, "w")

    if file == nil then
      error("error: file creation failed")
    end

    file.write(res_all)

    file.close()
  end
end

local ip = "http://localhost:8000/"
update_files(ip)
