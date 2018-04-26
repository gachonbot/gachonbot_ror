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
    

end