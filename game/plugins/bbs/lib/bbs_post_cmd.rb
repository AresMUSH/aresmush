module AresMUSH
  module Bbs
    class BbsPostCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :subject, :message

      def initialize
        self.required_args = ['name', 'subject', 'message']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("bbs")
        return false if !cmd.switch.nil?
        return false if cmd.args.nil?
        return true if cmd.args =~ /.+=.+\/.+/
        return true if cmd.args =~ /.+\/.+=.+/
        false
      end
      
      def crack!
        if (cmd.args =~ /.+=.+\/.+/)
          cmd.crack!(/(?<name>[^\=]+)=(?<subject>[^\/]+)\/(?<message>.+)/)
        else
          cmd.crack!(/(?<name>[^\/]+)\/(?<subject>[^\=]+)\=(?<message>.+)/)
        end
        self.subject = cmd.args.subject
        self.message = cmd.args.message
        self.name = cmd.args.name
      end
      
      def handle        
        Bbs.with_a_board(self.name, client) do |board|
          client.emit "Posted #{board.name} #{self.subject} --- #{self.message}!"
          post = BbsPost.create(bbs_board: board, 
            subject: self.subject, 
            message: self.message, author: client.char)
#          post.author = client.char
#          post.save!
          Global.client_monitor.emit_all "New message #{self.subject} posted to #{board.name} by #{client.name}"
        end
      end
    end
  end
end