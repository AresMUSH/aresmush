module AresMUSH    
  module Swade
    class AttributesCmd
      include CommandHandler
  
      def handle
        attrs = Global.read_config("Swade", "attributes")
        list = attrs.sort_by { |a| a['name']}
                    .map { |a| "%xh#{a['name'].ljust(15)}%xn #{a['description']}"}
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('Swade.attributes_title')
        client.emit template.render
      end
    end
  end
end