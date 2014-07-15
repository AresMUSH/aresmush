module AresMUSH
  module Bbs
    class BbsDeleteCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name, :num

      def initialize
        self.required_args = ['board_name', 'num']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("delete")
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.board_name = titleize_input(cmd.args.arg1)
        self.num = trim_input(cmd.args.arg2)
      end
      
      def handle
        Bbs.with_a_post(self.board_name, self.num, client) do |board, post| 
          
          if (!Bbs.can_edit_post(client.char, post))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
                             
          post.destroy
          client.emit_success(t('bbs.post_deleted', :board => board.name, :num => self.num))
        end
      end
    end
  end
end