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
        if @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl/dd[1]")
            return info.text.gsub("\r", "\r\n")
        end
    end
    
    def food_edu
        if @@day_value == 6 or @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=B"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
           return info.text.gsub("\r", "\r\n")
        end
    end
    
    def food_vision
        if @@day_value == 6 or @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=C"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
           return info.text.gsub("\r", "\r\n")
        end
    end
    
    def food_artd(day)
        day = day.split(" ").first
        case day
      when "월요일"   
        day = 1
      when "화요일"    
        day = 2
      when "수요일"
        day = 3
      when "목요일"
        day = 4
      when "금요일"
        day = 5
      when "토요일"
        day = 6
      when "일요일"
        day = 7        
        end
      
        if @@day_value == 6 or @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{day}]/dl/dd[1]")
            return info.text.gsub("\r", "\r\n")
        end
    end
    
    def food_edud(day)
        day = day.split(" ").first
        case day
      when "월요일"   
        day = 1
      when "화요일"    
        day = 2
      when "수요일"
        day = 3
      when "목요일"
        day = 4
      when "금요일"
        day = 5
      when "토요일"
        day = 6
      when "일요일"
        day = 7        
        end
        if @@day_value == 6 or @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=B"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{day}]/dl")
           return info.text.gsub("\r", "\r\n")
       end
    end
    
    def food_visiond(day)
        day = day.split(" ").first
        case day
      when "월요일"   
        day = 1
      when "화요일"    
        day = 2
      when "수요일"
        day = 3
      when "목요일"
        day = 4
      when "금요일"
        day = 5
      when "토요일"
        day = 6
      when "일요일"
        day = 7        
        end
        if @@day_value == 6 or @@day_value == 7
            return "주말은 운영하지 않습니다!"
        else
         url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=C"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
           return info.text.gsub("\r", "\r\n")
       end
    end
    
    def parse_library
      url ="http://dlibadm.gachon.ac.kr/GACHON_CENTRAL_BOOKING/webbooking/statusList.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           @seatname = Array.new
           @seatinfo = Array.new
           for i in 1..5
           @seatname << doc.css("#mainContents > div > div > div > table > tbody > tr:nth-child(#{i}) > td.left").text
           @seatinfo << doc.css("#mainContents > div > div > div > table > tbody > tr:nth-child(#{i}) > td.last.right.bold.blue.bg_blue").text
           end
      return "\n 열람실\t\t\t\t\t\t\t잔여좌석\n\n#{@seatname[0]}\t\t\t\t\t#{@seatinfo[0]}\n#{@seatname[1]}\t\t\t\t\t#{@seatinfo[1]}\n#{@seatname[2]}\t\t\t\t\t#{@seatinfo[2]}\n#{@seatname[3]}\t\t\t\t\t#{@seatinfo[3]}\n#{@seatname[4]}\t\t\t\t\t#{@seatinfo[4]}\n"  
    end
    
    def parse_schedule
      url ="http://m.gachon.ac.kr/day/day.jsp?boardType_seq=395"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           @month = Date.today.strftime("%m")
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@month}]/div")
           
      return "#{@month}월의 학사일정입니다!\n#{info.text.gsub("\r", "\n")}"
    end  
    
    def parse_notice
       url ="http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=358"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = Array.new
            for i in 1..5 do
             info << doc.xpath("//*[@id=\"contnet\"]/div[2]/ul/li[#{i}]/a/text()").text.strip
            end
            
      return "#{info[0]}\n\n#{info[1]}\n\n#{info[2]}\n\n#{info[3]}\n\n#{info[4]}\n\n"
    end
    
    def parse_scholar
      url ="http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=361"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = Array.new
            for i in 1..5 do
             info << doc.xpath("//*[@id=\"contnet\"]/div[2]/ul/li[#{i}]/a").text.strip
              end
              
      return "#{info[0]}\n\n#{info[1]}\n\n#{info[2]}\n\n#{info[3]}\n\n#{info[4]}\n\n"
    end
end
