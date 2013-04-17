module AresMUSH

  module Describe
    class RoomHeaderRenderer < TemplateRenderer
      def date
        DateTime.now.strftime("%F")
      end
    end    
  end
end