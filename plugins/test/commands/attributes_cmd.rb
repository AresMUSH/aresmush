module AresMUSH    
  module test
    class AttributesCmd
      include CommandHandler
  
      def handle
        attrs = Global.read_config("test", "attributes")
        list = attrs.sort_by { |a| a['name']}
                    .map { |a| "%xh#{a['name'].ljust(15)}%xn #{a['description']}"}
                    
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('test.attributes_title')
        client.emit template.render
      end
    end
  end
end