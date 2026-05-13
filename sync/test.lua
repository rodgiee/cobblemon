local sync = require("sync")

local ip = "http://localhost:8000/"

local files = sync.get_files(ip)

print(files)
