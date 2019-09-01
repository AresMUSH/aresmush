module AresMUSH
  module Who
    class WhoRequestHandler
      def handle(request)
        Who.web_who_report
      end
    end
  end
end


