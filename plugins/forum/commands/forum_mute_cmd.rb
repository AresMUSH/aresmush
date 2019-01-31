module AresMUSH
  module Forum
    class ForumMuteCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = cmd.switch_is?("mute") ? true : false
      end
      
      def handle       
        enactor.update(forum_muted: self.option)
        message = self.option ? t('forum.forum_muted') : t('forum.forum_unmuted')
        client.emit_success message
      end
    end
  end
end
