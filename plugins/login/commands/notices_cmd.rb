module AresMUSH
  module Login
    class NoticesCmd
      include CommandHandler

      def handle
        template = NoticesTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end