class JsonHelper
    
    
    def messageJson(text)
        @msg = {
              message: {
                  text: "#{text}"
              },
              keyboard: {
                type: "text",
              }
            }
            
        return @msg
    end
    
    def labelJson(text,label,url)
       @msg = {
              message: {
                  text: "#{text}",
              message_button: {
               label: "#{label}",
                url: "#{url}"
              }
              },
              keyboard: {
                type: "text",
              }
            }
            
        return @msg
    end    
    
    def foodJson
        @msg = {
              message: {
                  text: "오늘의 학식을 알려드릴게요! 건물을 선택해 주세요!"
              },
              keyboard: {
                type: "buttons",
                buttons: [" 예술대학", " 교육대학원", " 비전타워"]
              }
            }
            
        return @msg
    end

end