class PhoneHelper
   def initialize
       @Phones = Phone.all
   end
   
   def dept_number(dept)
        dept = dept.split(" ").first
        @dept_name = @Phones.find_by(name: "#{dept}").name
        @dept_number = @Phones.find_by(name: "#{dept}").number
        if @dept_name == nil
           return "없는 과입니다."
        else
        return "#{@dept_name}의 과사 전화번호는 \n#{@dept_number} 입니다."
        end
   end

end