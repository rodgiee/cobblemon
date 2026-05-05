local input = io.read()

local res = http.get("http://192.168.86.26:8000/" .. input .. ".lua")

if res == nil then
    error("error: file not found")
end

res = res.readAll()

local file = fs.open(input .. ".lua", "w")

file.write(res)
