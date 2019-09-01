$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Friends
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("friends", "shortcuts")
    end
    
    def self.achievements
      Global.read_config('friends', 'achievements')
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      return nil if !cmd.root_is?("friend")
      
      case cmd.switch
      when "add"
        return FriendAddCmd
      when "note"
        return FriendNoteCmd
      when "remove"
        return FriendRemoveCmd
      when nil
        return FriendsCmd
      end
      
      nil
    end
  end
end
