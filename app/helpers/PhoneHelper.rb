class PhoneHelper
   def initialize
       @Phones = Phone.all
   end
   
   def dept_number(dept)
        dept = dept.split(" ").first
        if @Phones.find_by(name: "#{dept}") == nil
           return "존재하지 않는 학과입니다. 정식 명칭을 입력해주세요!"
        else
        @dept_name = @Phones.find_by(name: "#{dept}").name
        @dept_number = @Phones.find_by(name: "#{dept}").number
        return "#{@dept_name}의 과사 전화번호는 \n#{@dept_number} 입니다."
        end
   end

end