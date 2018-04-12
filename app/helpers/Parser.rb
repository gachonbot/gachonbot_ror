class Parser
    def food_parser
         url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[1]/dl/dd[1]")
           puts info.text.gsub("\r", "\r\n")
    end
    
end
