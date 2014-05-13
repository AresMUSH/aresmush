module AresMUSH
  module Bbs
    class BbsNewCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("bbs") && cmd.switch_is?("new")
      end
      
      def handle
        BbsBoard.all_sorted.each do |b|
          b.bbs_posts.each_with_index do |p, i|
            if (p.is_unread?(client.char))
              Global.dispatcher.queue_command(client, Command.new("bbs #{b.name}/#{i+1}"))
              return
            end
          end
        end
        client.emit_success t('bbs.no_new_posts')
      end
    end
  end
end