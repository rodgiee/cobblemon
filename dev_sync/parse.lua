local parse = {}

--@return string[]
function parse.get_files()
  local result = {}
  local ip = "http://192.168.86.26:8000/"

  local response = http.get(ip)

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

return parse
