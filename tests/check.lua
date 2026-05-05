local res = peripheral.wrap("front").list()

local res_serialized = textutils.serialise(res)

local file = fs.open("log.txt", "w")

file.write(res_serialized)
