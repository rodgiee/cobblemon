local parse = require("parse")

for i, file in ipairs(parse.get_files()) do
  print(file)
end
