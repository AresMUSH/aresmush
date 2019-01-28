module AresMUSH
  module Login
    class NoticeMotdCmd
      include CommandHandler

      attr_accessor :notice
      
      def parse_args
        self.notice = cmd.args
      end
      
      def check_can_set
        return t('dispatcher.not_allowed')  if !Login.can_manage_login?(enactor)
        return nil
      end
      
      def handle
        Game.master.update(login_motd: self.notice)
        client.emit_success t('login.motd_set')
      end
    end
  end
end