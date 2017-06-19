module AresMUSH
  module Manage
    class FindsiteAllCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        sites = {}
        Character.all.each do |c|
          host = c.last_hostname || t('global.none')
          if (sites.has_key?(host))
            sites[host] << c.name
          else
            sites[host] = [ c.name ]
          end
        end

        list = sites.select{ |k,v| v.count > 1 }.map { |k, v| "#{v.join(', ')}%R%T#{k}" }
        template = BorderedListTemplate.new list
        client.emit template.render
        
      end
    end
  end
end