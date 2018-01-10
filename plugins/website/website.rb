$:.unshift File.dirname(__FILE__)

require 'diffy'

module AresMUSH
  module Website
        
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.get_cmd_handler(client, cmd, enactor)       
      case cmd.root      
      when "website"
        return WebsiteCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
        when "WebCmdEvent"
          return WebCmdEventHandler
        when "ConfigUpdatedEvent", "GameStartedEvent"
          return WebConfigUpdatedEventHandler
      end
      
      nil
    end
    
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "createWiki"
        return CreateWikiPageRequestHandler
      when "editWiki"
        return EditWikiPageRequestHandler
      when "files"
        return GetFilesRequestHandler
      when "game"
        return GetGameInfoRequestHandler
      when "wikiPage"
        return GetWikiPageRequestHandler
      when "wikiTagList"
        return GetWikiTagListRequestHandler
      when "wikiPageList"
        return GetWikiPageListRequestHandler
      when "wikiPageSource"
        return GetWikiPageSourceRequestHandler
      when "wikiPreview"
        return WikiPreviewRequestHandler
      when "wikiTag"
        return GetWikiTagRequestHandler
      when "sidebarInfo"
        return GetSidebarInfoRequestHandler
      when "uploadFile"
        return FileUploadRequestHandler
      end
      nil
    end
    
  end
end
