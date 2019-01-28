module AresMUSH
  module Website
    class WebErrorRequestHandler
      def handle(request)
        error = request.args[:error]
        Global.logger.error "Web client error: #{error}."
        {}
      end
    end
  end
end