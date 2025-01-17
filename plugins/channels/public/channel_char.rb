module AresMUSH
  class Character
    collection :channel_options, "AresMUSH::ChannelOptions"
    
    before_delete :delete_channel_options
    
    def delete_channel_options
      Channel.all.each { |c| Database.remove_from_set(c.characters, self) }
      channel_options.each { |c| c.delete }
    end
    
    def channels
      Channel.all.select { |c| c.characters.include?(self)}
    end
    
    def has_channel_blocked?(char)
      self.is_blocked?(char, "channel")      
    end
  end
end
