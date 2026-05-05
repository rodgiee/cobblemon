local res = http.get("http://192.168.86.26:8000/hello.lua").readAll()

print(res)
