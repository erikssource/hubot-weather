# Description:
#   Hubot script to show weather for some city
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_OWM_APIKEY: required, openweathermap API key
#   HUBOT_WEATHER_UNITS: optional, 'imperial' or 'metric'
#
# Commands:
#   hubot weather in <city> - Show today forecast for interested city.
#
# Author:
#   skibish

module.exports = (robot) ->
  robot.respond /weather in (.*)/i, (msg) ->
    APIKEY = process.env.HUBOT_OWM_APIKEY or null
    if APIKEY == null
      msg.send "HUBOT_OWM_APIKEY environment varibale is not provided for hubot-weather"
    UNITS = process.env.HUBOT_WEATHER_UNITS or "metric"
    if UNITS != "imperial"
      UNITS = "metric"
    UNIT = if UNITS == "imperial" then "F" else "C"
    msg.http("http://api.openweathermap.org/data/2.5/weather?q=#{msg.match[1]}&units=#{UNITS}&APPID=#{APIKEY}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        if data.message
          msg.send "#{data.message}"
        else
          msg.send "Forecast for today in #{data.name}, #{data.sys.country}\nCondition: #{data.weather[0].main}, #{data.weather[0].description}\nTemperature (min / max): #{data.main.temp_min}°#{UNIT} / #{data.main.temp_max}°#{UNIT}\nHumidity: #{data.main.humidity}%\nType: #{data.sys.type}\n\nLast updated: #{new Date(data.dt * 1000)}"
