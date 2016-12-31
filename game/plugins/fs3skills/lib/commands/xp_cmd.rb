module AresMUSH

  module FS3Skills
    class XpCmd
      include CommandHandler
      include CommandWithoutArgs
      
      def handle
        template = XpTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
