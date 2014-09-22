module AresMUSH
  module Channels
    def self.join_channel(name, client, char, chan_alias)
      Channels.with_a_channel(name, client) do |channel|
                
        if (Channels.is_on_channel?(char, channel))
          client.emit_failure t('channels.already_on_channel')
          return
        end
        
        if (!Channels.can_use_channel(char, channel))
          client.emit_failure t('channels.cant_use_channel')
          return
        end
        
        if (chan_alias.nil?)
          chan_alias = "+#{name[0..2].downcase}"
        end
            
        existing_alias = Channels.channel_for_alias(char, chan_alias)   
        if (!existing_alias.nil? && (existing_alias != channel))
          client.emit_failure t('channels.alias_in_use', :channel_alias => chan_alias)
          return
        end

        Channels.set_channel_option(char, channel, "alias", chan_alias)
        char.save!
        
        channel.characters << char
        channel.save!
        channel.emit t('channels.joined_channel', :name => char.name)
        client.emit_ooc t('channels.channel_alias_set', :name => name, :channel_alias => chan_alias)
      end
    end
  end
end