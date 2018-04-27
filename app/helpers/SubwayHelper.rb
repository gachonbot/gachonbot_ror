class SubwayHelper
    
   def show_gachon
        resp = HTTParty.get("http://swopenapi.seoul.go.kr/api/subway/56475774517475673131345a4c714e70/json/realtimeStationArrival/1/5/#{CGI.escape("가천대")}")
              @route = Array.new
              @routeMSG = Array.new
                resp.parsed_response["realtimeArrivalList"].each do |x|
                  @count = x["totalCount"]
                  @route << x["trainLineNm"]
                  @routeMSG << x["arvlMsg2"]
                end
                
              @result = Array.new
             for i in 0...@count.to_i
                 @result << "#{@route[i]}+\r\n+#{@routeMSG[i]}+\r\n"
             end
            
                
        return @result
   end
    
end