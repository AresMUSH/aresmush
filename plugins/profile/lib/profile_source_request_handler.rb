module AresMUSH
  module Profile
    class ProfileSourceRequestHandler
      def handle(request)
        char = Character.find_one_by_name request.args[:id]
        
        if (!char)
          return { error: "Character not found!" }
        end

      end
    end
  end
end