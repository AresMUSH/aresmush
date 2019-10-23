module AresMUSH
  module Who
    class WhoRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        who = {}
    
        Who.all_online.each do |char|
          who[char.name] = build_web_who_data(char)
        end
          
        {
          who_count: who.count,
          who: who.values.sort_by { |v| v[:name] }
        }
      end

      def build_web_who_data(char)
        {
          name: char.name,
          icon: Website.icon_for_char(char),
          status: Website.activity_status(char)
        }
      end
      
    end
  end
end


