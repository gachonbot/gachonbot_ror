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
    
    def chat_control
        @response = params[:content]
        @user_key = params[:user_key]
        
        if @response == "시작하기"
            @msg = {
              message: {
                  text: "안녕하세요 가천대학교 봇입니다! 궁금하신게 있으시면 다 대답해 드립니다! 대표적인 명령어는 명령어 보여줘! 로 확인 가능합니다!"
              },
              keyboard: {
                type: "text",
              }
            }
            render json: @msg, status: :ok
        elsif @response == "학식"
          url = 'http://m.gachon.ac.kr/menu/menu.jsp?gubun=A'
          page = RestClient.get(url)
           doc = Nokogiri::HTML(page)
           info = doc.css('#toggle-view > li:nth-child(1) > dl > dd:nth-child(2)')
            @msg = {
              message: {
                  text: "#{info.text}"
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

