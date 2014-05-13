module AresMUSH
  module Bbs
    class BbsCatchupCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :board_name

      def initialize
        self.required_args = ['board_name']
        self.help_topic = 'bbs'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("catchup")
      end
      
      def crack!
        self.board_name = titleize_input(cmd.args)
      end
      
      def handle
        Bbs.with_a_board(self.board_name, client) do |board|  
          unread_posts = board.bbs_posts.select { |p| p.is_unread?(client.char) }
          unread_posts.each do |p|
            p.mark_read(client.char)
          end
          client.char.save!
          client.emit_success t('bbs.caught_up', :board => board.name)
        end
      end
    end
  end
end