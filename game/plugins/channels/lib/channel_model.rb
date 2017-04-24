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
    attribute :muted, :type => DataType::Boolean
    attribute :announce, :type => DataType::Boolean, :default => true
    
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
    attribute :messages, :type => DataType::Array, :default => []
    attribute :recall_enabled, :type => DataType::Boolean, :default => true
    
    index :name_upcase
    
    set :roles, "AresMUSH::Role"
    set :characters, "AresMUSH::Character"

    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name.upcase
      
      if (!self.default_alias)
        self.default_alias = [self.name[0..1].trim.downcase, self.name[0..2].trim.downcase ].uniq
      end
    end      
        
    def display_name(include_markers = true)
      display = "#{self.color}#{self.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def emit(msg)
      message_with_title = "#{display_name} #{msg}"
      add_to_history message_with_title
      characters.each do |c|
        if (!Channels.is_muted?(c, self))
          client = c.client
          if (client)
            client.emit message_with_title
          end
        end
      end
    end
    
    def add_to_history(msg)
      return if !self.recall_enabled
      new_messages = (self.messages << msg)
      if (new_messages.count > 25)
        new_messages.shift
      end
      self.update(messages: new_messages)
    end
      
    
    def pose(name, msg)
      formatted_msg = PoseFormatter.format(name, msg)
      emit formatted_msg
    end
    
    def self.find_one_with_partial_match(name)
      channel = Channel.find_one_by_name(name)
      
      if (!channel)
        possible_matches = Channel.all.select { |c| c.name_upcase.starts_with?(name.upcase) }
        if (possible_matches.count == 1)
          channel = possible_matches.first
        end
      end
      
      channel
    end
  end
end
