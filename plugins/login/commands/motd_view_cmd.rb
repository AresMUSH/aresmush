module AresMUSH
  module Login
    class MotdViewCmd
      include CommandHandler

      def handle
        if (Game.master.login_motd)
          client.emit_ooc "#{t('login.motd_title')} #{Game.master.login_motd}"
        else
          client.emit_failure t('login.no_motd')
        end
      end
    end
  end
end