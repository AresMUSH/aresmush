$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Profile
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("profile", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      
      
      case cmd.root
      when "profile"
        case cmd.switch
        when "add"
          return ProfileAddCmd
        when "delete"
          return ProfileDeleteCmd
        when "edit"
          return ProfileEditCmd
        when nil
          return ProfileCmd
        end
      when "relationship"
        case cmd.switch
        when "add"
          return RelationshipAddCmd
        when "delete"
          return RelationshipDeleteCmd
        when "move"
          return RelationshipMoveCmd
        when "order"
          return RelationshipsOrderCmd
        when nil
          return RelationshipsCmd
        end
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "characters"
        return CharactersRequestHandler
      when "characterGroups"
        return CharacterGroupsRequestHandler
      when "character"
        return CharacterRequestHandler
      when "profileEdit"
        return ProfileEditRequestHandler
      when "profileSave"
        return ProfileSaveRequestHandler
      when "profileSource"
        return ProfileSourceRequestHandler
      when "searchChars"
        return SearchCharsRequestHandler
      end
      nil
    end
  end
end
