require 'nokogiri'
require 'rest-client'
require 'httparty'
require 'Parser'

class BasicController < ApplicationController
    def keyboard_init
       @msg =
            {
              type: "buttons",
              buttons: ["안녕!"]
            }
        render json: @msg, status: :ok
    end
    
    parser = Parser.new
    
    #요일 변경 함수
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

    def chat_control
        @response = params[:content]
        @user_key = params[:user_key]
        
        if @response == "안녕!"
            @msg = {
              message: {
                  text: "안녕하세요 가천대학교 봇입니다! 어떤 말이든 다 대답해 드립니다! 대표적인 명령어는 명령어 보여줘! 로 확인 가능합니다! 즐거운 #{exchange_day(Date.today.strftime("%A"))} 되세요!"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #오늘의 학식 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "학식"
          @msg = {
              message: {
                  text: "오늘의 학식을 알려드릴게요! 건물을 선택해 주세요!"
              },
              keyboard: {
                type: "buttons",
                buttons: [" 예술대학", " 교육대학원", " 비전타워"]
              }
            }
            render json: @msg, status: :ok
            
        #예술대학 학식    
        elsif @response == " 예술대학"
            #url ="http://m.gachon.ac.kr/menu/menu.jsp"
            #page = RestClient.get(url)
           #doc = Nokogiri::HTML(page)
           #info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl/dd[1]")
            @msg = {
              message: {
                  text: "#{parser.food_parser}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #교육대학원 학식
        elsif @response == " 교육대학원"
            url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=B"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
            @msg = {
              message: {
                  text: "#{info.text.gsub("\r", "\r\n")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        elsif @response == "db"
            @msg = {
              message: {
                  text: "#{Phone.all.find_by(id: 1).name}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #비전타워 학식
        elsif @response == " 비전타워"
            url ="http://m.gachon.ac.kr/menu/menu.jsp?gubun=C"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl")
            @msg = {
              message: {
                  text: "#{info.text.gsub("\r", "\r\n")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #명령어 보여줘!
        elsif @response == "명령어 보여줘!"
          @msg = {
              message: {
                  text: "대표적인 기능입니다!\n""학식"" = 오늘의 학식조회\n""!가천대역"" = 실시간 가천대역 열차도착 정보\n""!지하철 ""역명"""" = 가천대역에서 특정 역까지 가는 최단 경로 조회\n""날씨"" = 가천대의 현재 날씨,미세먼지 정보 조회\n ""중앙도서관 자리"" = 실시간 중앙도서관 남은좌석 조회"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
            
        #지도 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response == "지도"
            @msg = {
              message: {
                  text: "캠퍼스 지도입니다!",
              message_button: {
               label: "캠퍼스지도 보러가기.",
                url: "http://www.gachon.ac.kr/introduce/campus/campus_g.html"
              }
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
                    
        #중앙도서관 자리 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "중앙도서관" && "자리"
            url ="http://dlibadm.gachon.ac.kr/GACHON_CENTRAL_BOOKING/webbooking/statusList.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           @seatname = Array.new
           @seatinfo = Array.new
           for i in 1..5
           @seatname << doc.css("#mainContents > div > div > div > table > tbody > tr:nth-child(#{i}) > td.left").text
           @seatinfo << doc.css("#mainContents > div > div > div > table > tbody > tr:nth-child(#{i}) > td.last.right.bold.blue.bg_blue").text
            end
            @msg = {
              message: {
                  text: "\n 열람실\t\t\t\t\t\t\t잔여좌석\n\n#{@seatname[0]}\t\t\t\t\t#{@seatinfo[0]}\n#{@seatname[1]}\t\t\t\t\t#{@seatinfo[1]}\n#{@seatname[2]}\t\t\t\t\t#{@seatinfo[2]}\n#{@seatname[3]}\t\t\t\t\t#{@seatinfo[3]}\n#{@seatname[4]}\t\t\t\t\t#{@seatinfo[4]}\n"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #학사일정 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "학사일정"
            url ="http://m.gachon.ac.kr/day/day.jsp?boardType_seq=395"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           @month = Date.today.strftime("%m")
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@month}]/div")
            @msg = {
              message: {
                  text: "#{@month}월의 학사일정입니다!\n#{info.text.gsub("\r", "\n")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #공지사항 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "공지사항"
            url ="http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=358"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = Array.new
            for i in 1..5 do
             info << doc.xpath("//*[@id=\"contnet\"]/div[2]/ul/li[#{i}]/a/text()").text.strip
            end
            @msg = {
              message: {
                  text: "#{info[0]}\n\n#{info[1]}\n\n#{info[2]}\n\n#{info[3]}\n\n#{info[4]}\n\n",
              message_button: {
               label: "공지사항 바로가기.",
                url: "http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=358"
              }
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
         #공지사항 조회 기능
        #가천대학교 홈페이지 크롤링
        elsif @response.include? "장학소식"
            url ="http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=361"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = Array.new
            for i in 1..5 do
             info << doc.xpath("//*[@id=\"contnet\"]/div[2]/ul/li[#{i}]/a").text.strip
              end
            @msg = {
              message: {
                  text: "#{info[0]}\n\n#{info[1]}\n\n#{info[2]}\n\n#{info[3]}\n\n#{info[4]}\n\n",
              message_button: {
               label: "장학소식 바로가기.",
                url: "http://m.gachon.ac.kr/gachon/notice.jsp?boardType_seq=361"
              }
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #현재시간을 나타내주는 기능  
        elsif @response.include? "시간"
            @msg = {
              message: {
                  text: "#{Time.now}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #지하철 경로조회 기능
        #서울시 실시간 지하철 API
        elsif @response.include? "!지하철 "
            @destination = @response.delete("!지하철 ")
            resp = HTTParty.get("http://swopenapi.seoul.go.kr/api/subway/56475774517475673131345a4c714e70/json/shortestRoute/1/5/#{CGI.escape("가천대")}/#{CGI.escape(@destination)}")
            resp.parsed_response["shortestRouteList"].each do |x|
                          @route = x["shtStatnNm"]
                          @routeMSG = x["shtTransferMsg"]
                        end
            @msg = {
              message: {
                  text: "#{@destination}까지는 #{@routeMSG}\n\n경로 : #{@route.delete(" ").gsub(",", "->")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #가천대역 도착정보 조회 기능
        #서울시 실시간 지하철도착정보API
        elsif @response.include? "!가천대역"
            resp = HTTParty.get("http://swopenapi.seoul.go.kr/api/subway/56475774517475673131345a4c714e70/json/realtimeStationArrival/1/5/#{CGI.escape("가천대")}")
              @route = Array.new
              @routeMSG = Array.new
                resp.parsed_response["realtimeArrivalList"].each do |x|
                  @route << x["trainLineNm"]
                  @routeMSG << x["arvlMsg2"]
                end
            @msg = {
              message: {
                  text: "#{@route[0]}\n#{@routeMSG[0]}\n\n#{@route[1]}\n#{@routeMSG[1]}\n\n#{@route[1]}\n#{@routeMSG[1]}\n"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #날씨, 미세먼지 정보 조회 기능
        #sktelecom 날씨 API, data.go.kr대기오염API 이용
        elsif @response.include? "날씨"
              resp = HTTParty.get("https://api2.sktelecom.com/weather/current/hourly?version=1&lat=37.450745&lon=127.128804&appkey=af357d39-420c-49b0-ac22-d29381aa2a9b")
              resp.parsed_response["weather"]["hourly"].each do |x|
                @name = x["sky"]["name"]
                @tc =  x["temperature"]["tc"].to_i.round
                @tmin =  x["temperature"]["tmin"].to_i.round
                @tmax =  x["temperature"]["tmax"].to_i.round
              end 
              airresp = HTTParty.get("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=Yg%2Fv2SNnJRBBLW7RzCyiLenB1dTtvBca4kgw6L9wyVzY1M224M0RlRnxwasd9FMOMrWMqgD%2Ft0b%2BMDFdg5jWig%3D%3D&numOfRows=1&pageSize=1&pageNo=1&startPage=1&stationName=#{URI.escape("수내동")}&dataTerm=DAILY&ver=1.3")
              air = airresp.parsed_response['response']['body']['items']['item']['pm10Value'].to_i
              if(air>150)
                airValue = "매우나쁨"
                elsif(air>80)
                airValue = "나쁨"
                elsif(air>30)
                airValue = "보통"
              else
                airValue = "좋음"
              end
              @msg = {
              message: {
                  text: "현재 가천대의 날씨입니다!\n기상 : #{@name}\n현재온도 : #{@tc}도\n최저기온 : #{@tmin}도\n최고기온 : #{@tmax}도\n미세먼지 농도 : #{air}\t#{airValue}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #미세먼지 조회 기능
        #data.go.kr의 대기오염API 이용
        elsif @response.include? "미세먼지"
              resp = HTTParty.get("http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?serviceKey=Yg%2Fv2SNnJRBBLW7RzCyiLenB1dTtvBca4kgw6L9wyVzY1M224M0RlRnxwasd9FMOMrWMqgD%2Ft0b%2BMDFdg5jWig%3D%3D&numOfRows=1&pageSize=1&pageNo=1&startPage=1&stationName=#{URI.escape("수내동")}&dataTerm=DAILY&ver=1.3")
              air = resp.parsed_response['response']['body']['items']['item']['pm10Value'].to_i
              @msg = {
              message: {
                  text: "현재 가천대의 미세먼지농도 입니다!\n농도 : #{air}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
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
        
        #흡연구역 알려주는 기능  
        elsif @response.include? "흡연구역"
            @msg = {
              message: {
                  text: "교내 흡연구역은 공과대학2 정자 앞, 바이오나노연구원 4층 뒷문, 공과대학2 매점 앞, 가천관 가는 계단 앞, 바이오나노대학 건물 뒤편, 교육대학원 2층 옆, 중앙도서관 매점 앞, 주차장 공중전화 부스 앞, 학생회관 오른쪽 주차장 위, 일반대학원 정문 오른쪽, 예술대학1 분수대 옆, 예술대학2 1층 출입문 옆, 학군단 건물 구석, 글로벌센터 농구장 앞, IT대학 벤치 뒤 입니다!"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
        
        #샤워실 알려주는 기능
        elsif @response.include? "샤워실"
            @msg = {
              message: {
                  text: "샤워실은 산학협력관 5층, 가천관 B1층, IT대학 4층, 공과대학 1층, 학생회관 2층,4층(여자), 바이오나노대학 2,4층(여자), 3층, 종합운동장에 있습니다!"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            elsif @response.include? "ATM"
            @msg = {
              message: {
                  text: "\n신한은행 : 법과대학 1층, 비전타워 1층, 가천관 2층, 중앙도서관 1층\n국민은행 : 제2공학관 4층, 가천관 B1층\n우체국 은행 : 법과대학 1층"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #교내 편의점 알림    
        elsif @response.include? "편의점"
            @msg = {
              message: {
                  text: "가천관 2층(세븐일레븐), 공과대학2 4층, 프리덤광장(세븐일레븐), 비전타워A동(세븐일레븐), 비전타워B동(세븐일레븐), 예술대학1 1층, 중앙도서관 지하1층에 있습니다! ٩(ᐛ)و "
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #교내 카페 알림 기능
        elsif @response.include? "카페"&&"교내"
            @msg = {
              message: {
                  text: "IT대학앞 세븐일레븐옆에 파스쿠치, 가천관2층에 Grazie, 프리덤광장에 투썸플레이스, 카페로가 있습니다!\n٩(ᐛ)و "
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #개발자정보
        elsif @response == "개발자"
            @msg = {
              message: {
                  text: "가천대학교 컴퓨터공학과 14\n한승우\n010-9939-4434\ntuguri8@gmail.com"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
            elsif @response == "이길여"
            @msg = {
              message: {
                  text: "총장님사랑해요"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            
        #심심이 API
        else
          resp = HTTParty.get("http://api.simsimi.com/request.p?key=e7501386-fca8-4723-b278-36755e917526&lc=ko&ft=1.0&text=#{CGI.escape(@response)}")
            @msg = {
              message: {
                  text: resp.parsed_response["response"]
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
        end
    end
end
