module AresMUSH
  module Bbs
    class BbsDeleteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :name, :num

      def initialize
        self.required_args = ['name', 'num']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("delete")
      end
      
      # TODO - Check Permissions
      
      def crack!
        cmd.crack!( /(?<name>[^\=]+)\/(?<num>.+)/)
        self.name = titleize_input(cmd.args.name)
        self.num = trim_input(cmd.args.num)
      end
      
      def handle
        Bbs.with_a_post(self.name, self.num, client) do |board, post|          
          post.delete
          client.emit_success(t('bbs.post_deleted', :name => board.name, :num => self.num))
        end
      end
    end
  end
end