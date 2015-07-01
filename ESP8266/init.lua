-- Test script for ESP8266 reporting battery level to Thingspeak.
--  Copyright (C) 2015 Nicola Cimmino
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--   This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see http://www.gnu.org/licenses/.
--
-- This code has been tested on an ESP-12 module running NodeMCU

  -- Green LED
  gpio.mode(6,gpio.OUTPUT)
  
  -- We will be running init.lua and when done go back to sleep
  -- this gives us the possibility to bail out and get a chance
  -- to upload a new script. Just send a char to serial.  
  uart.on("data", 1,  
    function(data) 
      file.remove("init.lua")
      tmr.stop(1)
      uart.on("data")  
    end , 0)
  
  -- Give a sign of life for testing
  gpio.write(6,gpio.HIGH)

  -- Attempt WiFi setup
  wifi.setmode(wifi.STATION)
  wifi.sta.config("SSID","PASSWORD")
  
  -- Check we got network every 2 seconds.
  tmr.alarm(1,2000,1,checkNetwork())

  function checkNetwork()
    if wifi.sta.getip() == nil then
      print("Waiting network")
      return
    end
    tmr.stop(1)
    print("Network up")  
    sendBatteryVoltage()
  end

  -- Send current supply voltage to thingspeak channel.
  function sendBatteryVoltage()
    local voltage = node.readvdd33()*1
    
    conn=net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) responseReceived(payload) end )
    conn:connect(80,"184.106.153.149")
    conn:send("GET /update?key=WCX1TU0F3GMRY2BJ&field1=" .. voltage 
        .. " HTTP/1.1\r\nHost: api.thingspeak.com\r\n"
        .."Connection: close\r\nAccept: */*\r\n\r\n")
  end
 
  -- We got a reply from thingspeak
  -- LED off and deep sleep mode for 60s
 function responseReceived(data)
  gpio.write(6,gpio.LOW)
  node.dsleep(60000000, nil);
 end
  
    
