module AresMUSH
  module Bbs
    class BbsNewCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :board_name
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("new")
      end
      
      def crack!
        self.board_name = cmd.args
      end
      
      def handle
        
        first_unread = nil
        board = nil
        
        if (!self.board_name.nil?)
          Bbs.with_a_board(self.board_name, client) do |b|
            board = b
            first_unread = b.first_unread(client.char)
          end
        else
          BbsBoard.all_sorted.each do |b|
            board = b
            first_unread = b.first_unread(client.char)
            break if !first_unread.nil?
          end
        end
          
        if (first_unread.nil?)
          client.emit_success t('bbs.no_new_posts')
          return
        end

        client.emit RendererFactory.post_renderer.render(board, first_unread, client)
        first_unread.mark_read(client.char)
        client.program = { :last_bbs_post => first_unread }
      end
    end
  end
end