class StoreHelper
   def initialize
       @Stores = Store.all
   end
   
   def store_info(store)
        store = store.split(" ").first
        if @Stores.find_by(name: "#{store}") == nil
         return "등록되지 않은 장소 입니다. 등록을 원하시면 건의 부탁드립니다!"
        else
        @store_name = @Stores.find_by(name: "#{store}").name
        @store_number = @Stores.find_by(name: "#{store}").number
        @store_time = @Stores.find_by(name: "#{store}").time
        return "이름 : #{@store_name}\n\n전화번호\n#{@store_number}\n\n영업시간\n#{@store_time}"
       end
   end
    
   def store_phone(store)
       store = store.split(" ").first
       if @Stores.find_by(name: "#{store}") == nil
         return "등록되지 않은 장소 입니다. 등록을 원하시면 건의 부탁드립니다!"
        else
       @store_name = @Stores.find_by(name: "#{store}").name
       @store_number = @Stores.find_by(name: "#{store}").number
       @store_time = @Stores.find_by(name: "#{store}").time
        return "이름 : #{@store_name}\n\n전화번호\n#{@store_number}"
       end
   end
   
   def store_time(store)
       store = store.split(" ").first
       if @Stores.find_by(name: "#{store}") == nil
         return "등록되지 않은 장소 입니다. 등록을 원하시면 건의 부탁드립니다!"
        else
       @store_name = @Stores.find_by(name: "#{store}").name
       @store_number = @Stores.find_by(name: "#{store}").number
       @store_time = @Stores.find_by(name: "#{store}").time
        return "이름 : #{@store_name}\n\n영업시간\n#{@store_time}"
       end
   end
   
   def store_list
     stores = ""
     @Stores.each do |store|
      stores += "#{store.name}\n"
     end
     return stores
   end

end