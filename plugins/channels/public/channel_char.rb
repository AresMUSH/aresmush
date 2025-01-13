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
    
    def channel_blocks
      self.blocks.select { |b| b.block_type == "channel" }
    end
    
    def has_channel_blocked?(char)
      return false if !char
      self.channel_blocks.any? { |b| b.blocked == char }
    end
  end
end
