module AresMUSH
  module Demographics
    class FullCensusRequestHandler
      def handle(request)

        fields = Global.read_config("demographics", "census_fields")
        titles = fields.map { |f| f['title'] }
        
        chars = Chargen.approved_chars.sort_by { |c| c.name}

        census = []
        
        chars.each do |c|
          char_data = {}
          char_data['icon'] = Website.icon_for_char(c)
          char_data['mushname'] = c.name
          fields.each do |field_config|
            field = field_config["field"]
            title = field_config["title"]
            value = field_config["value"]

            char_data[title] = Profile.general_field(c, field, value)
          end
          
          census << char_data
        end
        
        {
          titles: titles,
          chars: census
        }
      end
    end
  end
end