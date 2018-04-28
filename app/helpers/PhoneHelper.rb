class PhoneHelper
   def initialize
       @Phones = Phone.all
   end
   
   def store_info(store)
        return "이름 : #{@Phones.find_by(name: "#{store}").name}\n\n전화번호\n#{@Phones.find_by(name: "#{store}").number}\n\n영업시간\n#{@Phones.find_by(name: "#{store}").time}"
   end
    
   def store_phone(store)
        return "이름 : #{@Phones.find_by(name: "#{store}").name}\n\n전화번호\n#{@Phones.find_by(name: "#{store}").number}"
   end
   
   def store_time(store)
        return "이름 : #{@Phones.find_by(name: "#{store}").name}\n\n영업시간\n#{@Phones.find_by(name: "#{store}").time}"
   end

end