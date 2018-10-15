module AresMUSH    
  module Fate
    class StuntsCmd
      include CommandHandler
  
      def handle
      
        stunts = Global.read_config("fate", "stunts")
        list = stunts.sort_by { |s| s['name']}
                    .map { |s| "%xh#{s['name']}%xn - #{s['description']}" }
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('fate.stunts_title')
        client.emit template.render
      end
    end
  end
end