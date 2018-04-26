require 'httparty'

class WeatherHelper
   
   def show_weather
        resp = HTTParty.get("https://api2.sktelecom.com/weather/current/hourly?version=1&lat=37.450745&lon=127.128804&appkey=af357d39-420c-49b0-ac22-d29381aa2a9b")
              resp.parsed_response["weather"]["hourly"].each do |x|
                @name = x["sky"]["name"]
                @tc =  x["temperature"]["tc"].to_i.round
                @tmin =  x["temperature"]["tmin"].to_i.round
                @tmax =  x["temperature"]["tmax"].to_i.round
        end
        
        return "현재 가천대의 날씨입니다!\n기상 : #{@name}\n현재온도 : #{@tc}도\n최저기온 : #{@tmin}도\n최고기온 : #{@tmax}도\n"
   end
   
   def show_air
        resp = HTTParty.get("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=Yg%2Fv2SNnJRBBLW7RzCyiLenB1dTtvBca4kgw6L9wyVzY1M224M0RlRnxwasd9FMOMrWMqgD%2Ft0b%2BMDFdg5jWig%3D%3D&numOfRows=1&pageSize=1&pageNo=1&startPage=1&stationName=#{URI.escape("수내동")}&dataTerm=DAILY&ver=1.3")
              air = resp.parsed_response['response']['body']['items']['item']['pm10Value'].to_i
        if(air>150)
                airValue = "매우나쁨"
                elsif(air>80)
                airValue = "나쁨"
                elsif(air>30)
                airValue = "보통"
              else
                airValue = "좋음"
        end      
        
       return "현재 가천대의 미세먼지농도 입니다!\n농도 : #{air}\t#{airValue}"
   end
   
    
end