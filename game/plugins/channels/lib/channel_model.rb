module AresMUSH
  class Character
    collection :channel_options, "AresMUSH::ChannelOptions"

    before_delete :delete_channel_options
    
    def delete_channel_options
      channel_options.each { |c| c.delete }
    end
    
    def channels
      Channel.all.select { |c| c.characters.include?(self)}
    end
  end
  
  class ChannelOptions  < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :channel, "AresMUSH::Channel"
    
    attribute :title
    attribute :aliases, :type => DataType::Array
    attribute :gagging, :type => DataType::Boolean
    
    def match_alias(a)
      return false if !self.aliases
      if (self.aliases.include?(a))
        return true
      end
      false
    end
    
    def alias_hint
      hints = []
      self.aliases.each do |a|
        hints << "%xh#{t('channels.channel_alias_hint', :alias => a)}%xH"
      end
      hint_text = hints.join(" #{t('global.or')} ")
      t('channels.channel_alias_set', :name => self.channel.name, :channel_alias => hint_text)
    end
  end
  
  class Channel < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :color, :default => "%xh"
    attribute :description
    attribute :announce, :type => DataType::Boolean, :default => true
    attribute :default_alias, :type => DataType::Array
    
    index :name_upcase
    
    set :roles, "AresMUSH::Role"
    set :characters, "AresMUSH::Character"

    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name.upcase
      if (!self.default_alias)
        self.default_alias = [self.name[0..1].downcase, self.name[0..2].downcase ]
      end
    end      
        
    def display_name(include_markers = true)
      display = "#{self.color}#{self.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def emit(msg)
      characters.each do |c|
        if (!Channels.is_gagging?(c, self))
          client = c.client
          if (client)
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
