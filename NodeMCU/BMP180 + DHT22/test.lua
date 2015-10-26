bmp180 = require("bmp180")
bmp180.init(sdaPin, sclPin)
bmp180.read(OSS)
t2 = bmp180.getTemperature()
p2 = bmp180.getPressure()
temperature2 = string.format("%.2f", t / 10)
pressure = p / 100
print("BMP Temperature: "..t2.." C\t|\t Pressure: "..p2.." hPa")
bmp180 = nil
package.loaded["bmp180"] = nil