module AresMUSH
  module Who
    class WhoRequestHandler
      def handle(request)
        who =  Global.client_monitor.logged_in.sort_by { |client, char| char.name}
          .map { |client, char| {
          name: char.name,
          icon: WebHelpers.icon_for_char(char)
          }
        }
                       
        {
          who_count: who.count,
          who: who
        }
      end
    end
  end
end


