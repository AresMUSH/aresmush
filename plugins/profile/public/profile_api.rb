module AresMUSH
  module Profile
    def self.general_field(char, field_type, value)
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
        TimeFormatter.format(Login.find_client(char).idle_secs)

      when 'connected'
        TimeFormatter.format(Login.find_client(char).connected_secs)

      when 'room'
        Who.who_room_name(char)

      when 'handle'
        char.handle ? "@#{char.handle.name}" : ""
      end
    end
    
    def self.get_player_tag(char)
      player_tag = char.profile_tags.select { |t| t.start_with?("player") }.first
      return nil if !player_tag
      player_tag = player_tag.after(":")
      player_tag.blank? ? nil : player_tag
    end
  end
end