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
      when "Monday"    #compare to 1
        day = "월요일"
      when "Tuesday"    #compare to 2
        day = "화요일"
      when "Wednesday"
        day = "수요일"
      when "Thursday"
        day= "목요일"
      when "Friday"
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
                buttons: ["창조관 학식", "아름관 학식", "비전타워 학식"]
              }
            }
            render json: @msg, status: :ok
            elsif @response == "창조관 학식"
            @msg = {
              message: {
                  text: "#{Time.now}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            elsif @response == "아름관 학식"
            @msg = {
              message: {
                  text: "#{Time.now}"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
            elsif @response == "비전타워 학식"
            @msg = {
              message: {
                  text: "#{Time.now}"
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

