module AresMUSH
  module Bbs
    class BbsNewCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("new")
      end
      
      def handle
        first_unread = nil
        board = nil
        BbsBoard.all_sorted.each do |b|
          board = b
          first_unread = b.first_unread(client.char)
          break if !first_unread.nil?
        end
          
        if (first_unread.nil?)
          client.emit_success t('bbs.no_new_posts')
          return
        end
        
        template = PostTemplate.new(board, first_unread, client)
        client.emit template.display
        
        Bbs.mark_read_for_player(client.char, first_unread)
        client.program[:last_bbs_post] = first_unread
      end
    end
  end
end