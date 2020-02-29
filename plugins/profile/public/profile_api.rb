module AresMUSH
  module Profile
    def self.general_field(char, field_type, value)
      client = Login.find_client(char)
      case field_type
      when 'demographic'
        char.demographic(value)

      when 'age'
        char.age
        
      when 'status_color'
        Status.status_color(char.status)

      when 'name'
        Demographics.name_and_nickname(char)

      when 'rank'
        char.rank

      when 'status'
        status_color = Status.status_color(char.status)
        "#{status_color}#{char.status}%xn"
   
      when 'group'
        char.group(value)

      when 'idle'
        client ? TimeFormatter.format(client.idle_secs) : '---'

      when 'connected'
        client ? TimeFormatter.format(client.connected_secs) : '---'

      when 'room'
        Who.who_room_name(char)

      when 'handle'
        char.handle ? "@#{char.handle.name}" : ""
        
      else 
        nil
      end
    end
    
    def self.get_player_tag(char)
      player_tag = char.profile_tags.select { |t| t.start_with?("player:") }.first
      return nil if !player_tag
      player_tag = player_tag.after(":")
      player_tag.blank? ? nil : player_tag
    end
    
    def self.validate_general_field_config(config)
      errors = []
      config.each do |entry|
        field = entry['field']
        title = entry['title']
        value = entry['value']
        if (!field)
          errors << "#{title} missing field."
        elsif (field.downcase != field)
          errors << "#{title} field names must be all lowercase."
        end
        
        if (field == 'demographic' && !Demographics.all_demographics.include?(value))
          errors << "#{title} #{value} is not a valid demographic."
        end
        
        if (field == 'group' && !Demographics.get_group(value))
          errors << "#{title} is not a valid group #{value}."
        end
      end
      return errors
    end
  end
end