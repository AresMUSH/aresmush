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
end
