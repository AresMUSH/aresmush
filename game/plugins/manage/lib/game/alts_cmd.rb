module AresMUSH
  module Manage
    class AltsCmd
      include CommandHandler
      include CommandRequiresLogin

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        sites = {}
        Character.all.each do |c|
          host = c.login_status ? c.login_status.last_hostname : nil
          if (sites.has_key?(host))
            sites[host] << c.name
          else
            sites[host] = [ c.name ]
          end
        end

        list = sites.select{ |k,v| v.count > 1 }.map { |k, v| "#{v.join(', ')}%R%T#{k}" }
        client.emit BorderedDisplay.list(list)
        
      end
    end
  end
end