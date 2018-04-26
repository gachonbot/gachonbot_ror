class SubwayHelper
    
   def show_gachon
        resp = HTTParty.get("http://swopenapi.seoul.go.kr/api/subway/56475774517475673131345a4c714e70/json/realtimeStationArrival/1/5/#{CGI.escape("가천대")}")
              @route = Array.new
              @routeMSG = Array.new
                resp.parsed_response["realtimeArrivalList"].each do |x|
                  @route << x["trainLineNm"]
                  @routeMSG << x["arvlMsg2"]
                end
                
        return "#{@route[0]}\n#{@routeMSG[0]}\n\n#{@route[1]}\n#{@routeMSG[1]}\n\n#{@route[2]}\n#{@routeMSG[2]}\n\n#{@route[3]}\n#{@routeMSG[3]}\n"
   end
    
end