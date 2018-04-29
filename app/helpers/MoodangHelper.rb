class MoodangHelper
    
  def moodang_arrival
      up = Array.new
      up = [840,845,855,900,915,930,945,1000,1015,1030,1045,1100,1115,1130,1145,1300,1315,1330,1345,1400,1415,1430,1445,1500,1515,1530,1545,1600,1615,1630,1645,1700,1715]
upArrival = up.find { |e| e > Time.now.strftime("%hour%min").to_i }
    case upArrival.to_s.length
    when 3
        upArrival = upArrival.to_s.insert(1, '시')+"분"
    when 4
        upArrival = upArrival.to_s.insert(2, '시')+"분"
    end
    return "다음 무당이 도착시간은 \n #{upArrival} 입니다"
  end
    
end