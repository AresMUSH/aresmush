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
 
    def self.init_plugin
      Website.rebuild_css
    end
    
    def self.get_cmd_handler(client, cmd, enactor)       
      case cmd.root      
      when "website"
        if (cmd.switch_is?("deploy"))
          return WebsiteDeployCmd
        else
          return WebsiteCmd
        end
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
        
      ## WIKI
      when "createWiki"
        return CreateWikiPageRequestHandler
      when "deleteWiki"
        return DeleteWikiPageRequestHandler
      when "editWiki"
        return EditWikiPageRequestHandler
      when "editWikiCancel"
        return CancelEditWikiPageRequestHandler
      when "searchWiki"
        return SearchWikiRequestHandler
      when "wikiPage"
        return GetWikiPageRequestHandler
      when "wikiTagList"
        return GetWikiTagListRequestHandler
      when "wikiPageList"
        return GetWikiPageListRequestHandler
      when "wikiPageSource"
        return GetWikiPageSourceRequestHandler
      when "wikiTag"
        return GetWikiTagRequestHandler

      ## FILES
      when "deleteFile"
        return FileDeleteRequestHandler
      when "files"
        return GetFilesRequestHandler
      when "updateFile"
        return FileUpdateRequestHandler
      when "uploadFile"
        return FileUploadRequestHandler

      ## LOGS
      when "logs"
        return GetLogsRequestHandler
      when "log"
        return GetLogRequestHandler
      when "webError"
        return WebErrorRequestHandler
      
      ## TINKER
      when "getTinker"
        return GetTinkerRequestHandler
      when "saveTinker"
        return SaveTinkerRequestHandler

      ## SETUP
      when "getConfig"
        return GetConfigRequestHandler
      when "saveConfig"
        return SaveConfigRequestHandler
      when "getTextFile"
        return GetTextFileRequestHandler
      when "saveTextFile"
        return SaveTextFileRequestHandler
      when "getSetupIndex"
        return SetupIndexRequestHandler
      when "getColors"
        return GetColorsRequestHandler
      when "saveColors"
        return SaveColorsRequestHandler
        
      ## MISC
      when "game"
        return GetGameInfoRequestHandler
      when "editGame"
        return EditGameRequestHandler
      when "saveGame"
        return SaveGameRequestHandler
      when "editPlugins"
        return EditPluginsRequestHandler
      when "savePlugins"
        return SavePluginsRequestHandler
      when "markdownPreview"
        return MarkdownPreviewRequestHandler
      when "recentChanges"
        return GetRecentChangesRequestHandler
      when "sidebarInfo"
        return GetSidebarInfoRequestHandler
      when "shutdown"
        return ShutdownRequestHandler
      when "deployWebsite"
        return DeployWebsiteRequestHandler
      end
      nil
    end
    
  end
end
