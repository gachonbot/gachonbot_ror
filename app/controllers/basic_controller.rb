require 'nokogiri'
require 'rest-client'
require 'httparty'

class BasicController < ApplicationController
    def keyboard_init
       @msg =
            {
              type: "buttons",
              buttons: ["시작하기"]
            }
        render json: @msg, status: :ok
    end
    
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
        
        if @response == "시작하기"
            @msg = {
              message: {
                  text: "안녕하세요 가천대학교 봇입니다! 궁금하신게 있으시면 다 대답해 드립니다! 대표적인 명령어는 명령어 보여줘! 로 확인 가능합니다! 즐거운 #{exchange_day(Date.today.strftime("%A"))} 되세요!"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
        elsif @response.include? "학식"
          @msg = {
              message: {
                  text: "오늘의 학식을 알려드릴게요! 건물을 선택해 주세요!"
              },
              keyboard: {
                type: "buttons",
                buttons: ["예술대학", "교육대학원", "비전타워"]
              }
            }
            render json: @msg, status: :ok
            elsif @response == "예술대학"
            url ="http://m.gachon.ac.kr/menu/menu.jsp"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@@day_value}]/dl/dd[1]")
            @msg = {
              message: {
                  text: "#{info.text.gsub("\r", "\r\n")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            elsif @response == "교육대학원"
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
            elsif @response == "비전타워"
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
            elsif @response.include? "중앙도서관 자리"
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
            elsif @response.include? "학사일정"
            url ="http://m.gachon.ac.kr/day/day.jsp?boardType_seq=395"
            page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           @month = Date.today.strftime("%m")
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@month}]/div")
            @msg = {
              message: {
                  text: "#{@month}월의 학사일정!\n#{info.text.gsub("\r", "\n")}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
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
        else
          resp = HTTParty.get("http://sandbox.api.simsimi.com/request.p?key=e7501386-fca8-4723-b278-36755e917526&lc=ko&ft=1.0&text=#{CGI.escape(@response)}")
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