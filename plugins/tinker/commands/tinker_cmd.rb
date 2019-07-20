module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
      new_changes = []
      Game.master.recent_changes.each do |change|
        case change['type'] 
        when 'wiki'
         new_changes << { type: 'wiki', message: "#{change['name']} updated.", data: { page_name: change['name'], version_id: change['id'] } }
        when 'char'
          new_changes << { type: 'char', message: "#{change['name']} updated.", data: { char_name: change['name'], version_id: change['id'] } }
        end
      end
        Game.master.update(recent_changes: new_changes)
        client.emit_success "Done!"
      end

    end
  end
end
