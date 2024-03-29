require 'nokogiri'
require 'rest-client'
require 'httparty'
require 'Parser'
require 'JsonHelper'
require 'InfoHelper'
require 'WeatherHelper'
require 'SubwayHelper'
require 'StoreHelper'
require 'PhoneHelper'
require 'MoodangHelper'

class BasicController < ApplicationController
    def keyboard_init
       @msg =
            {
              type: "buttons",
              buttons: ["안녕!"]
            }
        render json: @msg, status: :ok
    end
    

    def chat_control
        
        
        @response = params[:content]
        @user_key = params[:user_key]
        
            parser = Parser.new
            jsonHelper = JsonHelper.new
            infoHelper = InfoHelper.new
            weatherHelper = WeatherHelper.new
            subwayHelper = SubwayHelper.new
            storeHelper = StoreHelper.new
            phoneHelper = PhoneHelper.new
            moodangHelper = MoodangHelper.new
            
        if @response == "안녕!"
            render json: jsonHelper.messageJson(infoHelper.show_start)

        #오늘의 학식 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "학식"&&"오늘"
            render json: jsonHelper.foodJson
            
        #예술대학 학식    
        elsif @response == " 예술대학"
            render json: jsonHelper.messageJson(parser.food_art)
            
        #교육대학원 학식
        elsif @response == " 교육대학원"
            render json: jsonHelper.messageJson(parser.food_edu)
            
        #비전타워 학식
        elsif @response == " 비전타워"
           render json: jsonHelper.messageJson(parser.food_vision)
           
       elsif @response.include? "학식"&&"내일"
            render json: jsonHelper.tomorrowfoodJson
            
        #예술대학 학식    
        elsif @response == "  예술대학"
            render json: jsonHelper.messageJson(parser.food_artTomorrow)
            
        #교육대학원 학식
        elsif @response == "  교육대학원"
            render json: jsonHelper.messageJson(parser.food_eduTomorrow)
            
        #비전타워 학식
        elsif @response == "  비전타워"
           render json: jsonHelper.messageJson(parser.food_visionTomorrow)
           
        #지도 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif (@response.include? "학교" or @response.include? "캠퍼스") and (@response.include? "지도" or @response.include? "맵")
            render json: jsonHelper.labelJson("캠퍼스 지도입니다!","캠퍼스지도 보러가기","http://www.gachon.ac.kr/introduce/campus/campus_g.html")
                    
        #중앙도서관 자리 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif (@response.include? "중앙도서관" or @response.include? "중도") and (@response.include? "자리" or @response.include? "좌석")
            render json: jsonHelper.messageJson(parser.parse_library)
            
        #학사일정 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "학사일정"
            render json: jsonHelper.messageJson(parser.parse_schedule)
            
        #공지사항 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "공지사항"
            render json: jsonHelper.labelJson(parser.parse_notice,"공지사항 바로가기","http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=358")
            
         #공지사항 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "장학소식"
            render json: jsonHelper.labelJson(parser.parse_scholar,"장학소식 바로가기","http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=361")
            
        elsif @response.include? "가게정보"
            render json: jsonHelper.messageJson(storeHelper.store_info(@response))
            
        elsif @response.include? "가게전화번호"
            render json: jsonHelper.messageJson(storeHelper.store_phone(@response))
            
        elsif @response.include? "가게영업시간"
            render json: jsonHelper.messageJson(storeHelper.store_time(@response))

        elsif @response.include? "가게리스트"
            render json: jsonHelper.messageJson(storeHelper.store_list)            
            
        elsif @response.include? "과사번호"
            render json: jsonHelper.messageJson(phoneHelper.dept_number(@response))
            
        elsif @response.include? "과리스트"
            render json: jsonHelper.messageJson(phoneHelper.dept_list)
            
        
        elsif @response.include? "무당이" and (@response.include? "언제와" or @response.include? "시간")
            render json: jsonHelper.moodangJson
            
            
        elsif @response == "정문 -> 기숙사" or @response == "기숙사 -> 정문"
            render json: jsonHelper.messageJson(moodangHelper.moodang_arrival)
            
        #지하철 경로조회 기능
        #서울시 실시간 지하철 API
        elsif @response.include? "!지하철 "
            @destination = @response.delete("!지하철 ")
            resp = HTTParty.get("http://swopenapi.seoul.go.kr/api/subway/56475774517475673131345a4c714e70/json/shortestRoute/1/5/#{CGI.escape("가천대")}/#{CGI.escape(@destination)}")
            resp.parsed_response["shortestRouteList"].each do |x|
                          @route = x["shtStatnNm"]
                          @routeMSG = x["shtTransferMsg"]
                        end
            render json: jsonHelper.messageJson("#{@destination}까지는 #{@routeMSG}\n\n경로 : #{@route.delete(" ").gsub(",", "->")}")
            
        #가천대역 도착정보 조회 기능
        #서울시 실시간 지하철도착정보API
        elsif @response.include? "가천대역"
              render json: jsonHelper.messageJson(subwayHelper.show_gachon)
            
        #날씨, 미세먼지 정보 조회 기능
        #sktelecom 날씨 API, data.go.kr대기오염API 이용
        elsif @response.include? "날씨"
              render json: jsonHelper.messageJson(weatherHelper.show_weather)
            
        #미세먼지 조회 기능
        #data.go.kr의 대기오염API 이용
        elsif @response.include? "미세먼지"
              render json: jsonHelper.messageJson(weatherHelper.show_air)
              
              
        elsif @response == "170516"
            @msg = {
              message: {
                  text: "현지야사랑해"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
            
        #명령어 보여줘!
        elsif @response == "명령어 보여줘!"
            render json: jsonHelper.messageJson(infoHelper.show_command)
            
        #흡연구역 알려주는 기능  
        elsif @response.include? "흡연구역"
            render json: jsonHelper.messageJson(infoHelper.show_smoke)
        
        #샤워실 알려주는 기능
        elsif @response.include? "샤워실"
            render json: jsonHelper.messageJson(infoHelper.show_shower)
        
        elsif @response.include? "ATM"
            render json: jsonHelper.messageJson(infoHelper.show_atm)
            
        #교내 편의점 알림    
        elsif @response.include? "편의점"
            render json: jsonHelper.messageJson(infoHelper.show_conv)
            
        #교내 카페 알림 기능
        elsif @response.include? "카페"&&"교내"
            render json: jsonHelper.messageJson(infoHelper.show_cafe)
            
        #개발자정보
        elsif @response == "개발자" or @response == "만든사람"
            render json: jsonHelper.messageJson(infoHelper.show_developer)
            
        elsif @response == "이길여"
            render json: jsonHelper.messageJson(infoHelper.show_boss)
            
        elsif @response.include? "허승회"
            render json: jsonHelper.messageJson("컴퓨터공학과 14학번 머리긴애?")
            
        elsif @response.include? "한승우"
            render json: jsonHelper.messageJson("이거만든사람")
            
        #심심이 API
        else
          resp = HTTParty.get("http://api.simsimi.com/request.p?key=e7501386-fca8-4723-b278-36755e917526&lc=ko&ft=1.0&text=#{CGI.escape(@response)}")
          render json: jsonHelper.messageJson(resp.parsed_response["response"])
        end
    end
end
