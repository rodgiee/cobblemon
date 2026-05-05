--@return string[]
local function get_files()
  local result = {}
  local ip = "http://192.168.86.26:8000/"

  local response = http.get(ip)

  if response == nil then
    error("error: connection is down")
  end

  local line = response.readLine()
  while line ~= nil do
    if line:find("<li>") then
      --result:insert(line:match('"(.-)"'))
      table.insert(result, line:match('"(.-)"'))
    end
    line = response.readLine()
  end
  return result
end

local function update_files()
  for i, file in ipairs(get_files()) do
    local res = http.get("http://192.168.86.26:8000/" .. file)

    if res == nil then
      error("error: file not found")
    end

    res = res.readAll()

    local file = fs.open(file, "w")

    file.write(res)
  end
end

update_files()
