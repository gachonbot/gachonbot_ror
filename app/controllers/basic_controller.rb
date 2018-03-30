require 'nokogiri'
require 'rest-client'


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
        @day_value = 1
        day = "월요일"
      when "Tuesday"    
        @day_value = 2
        day = "화요일"
      when "Wednesday"
        @day_value = 3
        day = "수요일"
      when "Thursday"
        @day_value = 4
        day= "목요일"
      when "Friday"
        @day_value = 5
        day = "금요일"
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
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{day_value}]/dl/dd[1]")
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
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@day_value}]/dl")
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
           info = doc.xpath("//*[@id=\"toggle-view\"]/li[#{@day_value}]/dl")
            @msg = {
              message: {
                  text: "#{info.text.gsub("\r", "\r\n")}"
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
        else
            @msg = {
              message: {
                  text: "잘못된 명령어를 입력하셨습니다."
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
        end
      end
end