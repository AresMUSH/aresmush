module AresMUSH
  module Login
    class TosCmd
      include CommandHandler
      
      def allow_without_login
        true
      end      
      
      def handle
        template = BorderedDisplayTemplate.new(Login.terms_of_service)
        client.emit template.render
      end
    end
  end
end
