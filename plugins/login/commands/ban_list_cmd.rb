module AresMUSH
  module Login
    class BanListCmd
      include CommandHandler
      
      def check_admin
        return nil if enactor.is_admin?
        return t('dispatcher.not_allowed')
      end
      
      def handle
        list = (Game.master.banned_sites || {})
           .map { |k, v| "#{k.ljust(20)} #{v}"}
        template = BorderedListTemplate.new list, t('login.ban_list_title')
        client.emit template.render
        
      end
    end
  end
end
