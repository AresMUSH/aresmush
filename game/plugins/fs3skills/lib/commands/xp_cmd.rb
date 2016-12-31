module AresMUSH

  module FS3Skills
    class XpCmd
      include CommandHandler
      
      def handle
        template = XpTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
