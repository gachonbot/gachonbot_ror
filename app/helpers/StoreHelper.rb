class StoreHelper
   def initialize
       @Stores = Store.all
   end
   
   def store_info(store)
        store = store.split(" ").first
        return "이름 : #{@Stores.find_by(name: "#{store}").name}\n\n전화번호\n#{@Stores.find_by(name: "#{store}").number}\n\n영업시간\n#{@Stores.find_by(name: "#{store}").time}"
   end
    
   def store_phone(store)
       store = store.split(" ").first
        return "이름 : #{@Stores.find_by(name: "#{store}").name}\n\n전화번호\n#{@Stores.find_by(name: "#{store}").number}"
   end
   
   def store_time(store)
       store = store.split(" ").first
        return "이름 : #{@Stores.find_by(name: "#{store}").name}\n\n영업시간\n#{@Stores.find_by(name: "#{store}").time}"
   end

end