module AresMUSH
  module Profile
    class BackupCharRequestHandler
      def handle(request)
        
        enactor = request.enactor
        char = Character[request.args['id']]
        
        
        error = Website.check_login(request)
        return error if error
        
        if (!char)
          return { error: t('webportal.not_found') }
        end

        Global.logger.info "#{enactor.name} creating backup for #{char.name}."
        
        manager = Profile.can_manage_profiles?(enactor)
        
        if (!Profile.can_manage_char_profile?(enactor, char))
          return { error: t('dispatcher.not_allowed') }
        end

        error = Profile.export_wiki_char(char)
        if (error)
          return { error: error }
        end
        
        {    
        }
      end
    end
  end
end


