module AresMUSH
  module Bbs
    class BbsListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle       
        template = BoardListTemplate.new(client.char, client) 
        template.render
      end
    end
  end
end
