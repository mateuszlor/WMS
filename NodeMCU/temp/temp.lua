port = 80
pin = 2
key = "6W8XPZNUZZA57OYZ"

function readData()
    status,temperature,humidity,t,h = dht.read(pin)
    
    if( status == dht.OK ) then
      print("DHT Temperature:"..temperature.."\t|\t".."Humidity:"..humidity)      sendData()
    elseif( status == dht.ERROR_CHECKSUM ) then
      print( "DHT Checksum error." )
    elseif( status == dht.ERROR_TIMEOUT ) then
      print( "DHT Time out." )
    end
end

function sendData()
    conn=net.createConnection(net.TCP, 0) 
    conn:on("receive", function(conn, payload) print(payload) end)
    -- api.thingspeak.com 184.106.153.149
    conn:connect(80,'184.106.153.149') 
    conn:send("GET /update?key="..key.."&field1="..temperature.."&field2="..humidity.." HTTP/1.1\r\n") 
    conn:send("Host: api.thingspeak.com\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
    conn:send("\r\n")
    conn:on("sent",function(conn)
                          conn:close()
                      end)
end

tmr.alarm(0, 60000, 1, function() readData() end )