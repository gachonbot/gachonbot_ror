class Parser
    def food_parser
         url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl/dd[1]")
           return info.text.gsub("\r", "\r\n")
    end
    
end