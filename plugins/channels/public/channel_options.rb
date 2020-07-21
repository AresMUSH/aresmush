module AresMUSH
  class ChannelOptions  < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :channel, "AresMUSH::Channel"
    
    attribute :title
    attribute :aliases, :type => DataType::Array
    attribute :muted, :type => DataType::Boolean
    attribute :color
    attribute :show_titles, :type => DataType::Boolean, :default => true
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
      list = self.aliases
      list << self.channel.name
      list.each do |a|
        hints << "%xh#{t('channels.channel_alias_hint', :alias => a)}%xH"
      end
      hint_text = hints.join(" #{t('global.or')} ")
      t('channels.channel_alias_set', :name => self.channel.name, :channel_alias => hint_text)
    end
  end
end
