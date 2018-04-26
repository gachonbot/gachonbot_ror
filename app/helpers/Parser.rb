require 'nokogiri'
require 'rest-client'

class Parser
    def initialize
    exchange_day(Date.today.strftime("%A"))
    end
    
    #요일 변경 함수.
    def exchange_day(day)
      case day
      when "Monday"   
        @@day_value = 1
        day = "월요일"
      when "Tuesday"    
        @@day_value = 2
        day = "화요일"
      when "Wednesday"
        @@day_value = 3
        day = "수요일"
      when "Thursday"
        @@day_value = 4
        day= "목요일"
      when "Friday"
        @@day_value = 5
        day = "금요일"
      when "Saturday"
        @@day_value = 6
        day = "토요일"
      when "Sunday"
        @@day_value = 7
        day = "일요일"        
      end
    end
    
    def food_art
         url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl/dd[1]")
           return info.text.gsub("\r", "\r\n")
    end
    
    def food_edu
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=B"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
           return info.text.gsub("\r", "\r\n")
    end
    
    def food_vision
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=C"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
           return info.text.gsub("\r", "\r\n")
    end
  
end
