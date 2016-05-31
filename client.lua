local socket = require("socket")
 
local host = "192.168.131.7"
local port = "12345"
local sock = assert(socket.connect(host, port))
sock:settimeout(0)
  
channel = love.thread.getChannel("client")
print("Press enter after input something:")
 
local input, recvt, sendt, status
while true do
    input = channel:pop()
    if input then
        print("client pop out"..input)
        assert(sock:send(input .. "\n"))
    end
    recvt, sendt, status = socket.select({sock}, nil, 1)
    while #recvt > 0 do
        local response, receive_status = sock:receive()
        if receive_status ~= "closed" then
            if response then
                print(response)
                recvt, sendt, status = socket.select({sock}, nil, 1)
            end
        else
            break
        end
    end
end
