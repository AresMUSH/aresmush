module AresMUSH
  class Channel < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :color, :default => "%xh"
    attribute :description
    attribute :announce, :type => DataType::Boolean, :default => true
    attribute :default_alias, :type => DataType::Array
    attribute :recall_enabled, :type => DataType::Boolean, :default => true
    
    index :name_upcase
    
    set :join_roles, "AresMUSH::Role"
    set :talk_roles, "AresMUSH::Role"
    set :roles, "AresMUSH::Role"
    set :characters, "AresMUSH::Character"
    
    collection :channel_messages, "AresMUSH::ChannelMessage"

    before_save :save_upcase
    before_delete :delete_refs
    
    # DEPRECATED
    attribute :messages, :type => DataType::Array, :default => []
    
    def save_upcase
      self.name_upcase = self.name.upcase
      
      if (!self.default_alias)
        aliases = []
        if (self.name.length >= 3)
          aliases << self.name[0..2].strip.downcase 
        end
        if (self.name.length >= 2)
          aliases << self.name[0..1].strip.downcase
        end
        self.default_alias = aliases.uniq
      end
    end      
    
    def delete_refs
      ChannelOptions.all.select { |c| c.channel_id == self.id }.each { |c| c.delete }
      self.channel_messages.each { |c| c.delete }
    end
        
    def display_name(include_markers = true)
      display = "#{self.color}#{self.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def add_to_history(msg, author)
      return if !self.recall_enabled
      ChannelMessage.create(message: msg, character: author, channel: self )
      if (self.channel_messages.count > Channels.recall_buffer_size)
        self.sorted_channel_messages.first.delete
      end
    end      
    
    def last_activity
      last_msg = self.sorted_channel_messages[-1]
      return nil if !last_msg
      return last_msg.created_at
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
    
    def sorted_channel_messages
      self.channel_messages.to_a.sort_by { |m| m.created_at }
    end
    
    def set_talk_roles(role_names)
      role_names_upcase = role_names.map { |r| r.upcase }
      self.talk_roles.each do |r|
        if (!role_names_upcase.include?(r.name_upcase))
          self.talk_roles.delete r
        end
      end
    
      role_names.each do |r|
        role = Role.find_one_by_name(r)
        if (!self.talk_roles.include?(role))
          self.talk_roles.add role
        end
      end
    end
    
    def set_join_roles(role_names)
      role_names_upcase = role_names.map { |r| r.upcase }
      self.join_roles.each do |r|
        if (!role_names_upcase.include?(r.name_upcase))
          self.join_roles.delete r
        end
      end
    
      role_names.each do |r|
        role = Role.find_one_by_name(r)
        if (!self.join_roles.include?(role))
          self.join_roles.add role
        end
      end
    end
  end
end
