module AresMUSH
  class Character
    collection :channel_options, "AresMUSH::ChannelOptions"

    set :channels, "AresMUSH::Channel"
  end
  
  class ChannelOptions  < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :channel, "AresMUSH::Channel"
  end
  
  class Channel < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :color
    attribute :description
    attribute :announce, DataType::Boolean
    attribute :default_alias
    
    set :roles, "AresMUSH::Role"
    set :characters, "AresMUSH::Character"
        
    def set_default_alias
      self.default_alias = [self.name[0..1].downcase, self.name[0..2].downcase ]
    end
    
    def display_name(include_markers = true)
      display = "#{self.color}#{self.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def emit(msg)
      characters.each do |c|
        if (!Channels.is_gagging?(c, self))
          client = c.client
          if (!client.nil?)
            client.emit "#{display_name} #{msg}"
          end
        end
      end
    end
    
    def pose(name, msg)
      emit PoseFormatter.format(name, msg)
    end
  end
end
