port = 80
dhtPin = 2
sclPin = 5
sdaPin = 6
OSS = 1 -- oversampling setting <0-3> (BMP-180)
key = "U5HGQRFROH05PO6U"

function readDht()
    status,temperature,humidity,t,h = dht.read(dhtPin)
    
    if( status == dht.OK ) then
      print("DHT Temperature: "..temperature.." C\t|\t".."Humidity: "..humidity.." %")
      dhtCorrect = true
    else
        dhtCorrect = false
        if( status == dht.ERROR_CHECKSUM ) then
            print( "DHT Checksum error." )
        elseif( status == dht.ERROR_TIMEOUT ) then
            print( "DHT Time out." )
        end
    end
end

function readPressure()  
    print("#1")
    bmp = require("bmp085")
    print("#2")
    bmp.init(sdaPin, sclPin)
    print("#3")
    tmr.delay(1000)
    print("#3.5")
    t2 = bmp.getUT(true)
    print("#4 "..t2)
    p2 = bmp.getUP()
    print("#5 "..p2)

--    if(p == nil) then
--        
--        print("BMP reading error")
--        bmpCorrect = false
--    else
        bmpCorrect = true
        temperature2 = string.format("%.2f", t2 / 10)
        pressure = string.format("%.2f", p2 / 100)
        print("BMP Temperature: "..temperature2.." C\t|\t".."Pressure: "..pressure.." hPa")
--    end
    print("#6")
    bmp = nil
    print("#7")
    package.loaded["bmp085"] = nil
end

function sendData()
    url = "/update?key="..key

    if(dhtCorrect) then
        url = url.."&field1="..temperature.."&field2="..humidity
    end

    if(bmpCorrect) then
        url = url.."&field3="..pressure.."&field4="..temperature2
    end

    if(dhtCorrect or bmpCorrect) then
        conn=net.createConnection(net.TCP, 0) 
        conn:on("receive", function(conn, payload) print(payload) end)
        -- api.thingspeak.com 184.106.153.149
        conn:connect(80,'184.106.153.149') 
        conn:send("GET "..url.." HTTP/1.1\r\n") 
        conn:send("Host: api.thingspeak.com\r\n") 
        conn:send("Accept: */*\r\n") 
        conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
        conn:send("\r\n")
        conn:on("sent",function(conn)
                              conn:close()
                          end)
    end
end

function doReadings()
    readDht()
    readPressure()
    sendData()
end

-- MAIN
tmr.alarm(0, 60000, 1, function() doReadings() end )
