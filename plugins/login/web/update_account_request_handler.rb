module AresMUSH
  module Login
    class UpdateAccountInfoRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args['name']
        char_alias = request.args['alias'] || ""
        email = request.args['email']
        timezone = request.args['timezone']
        pw = request.args['confirm_password']
        unified_play_screen = (request.args['unified_play_screen'] || "").to_bool
        editor = request.args['editor'] || "WYSIWYG"

        error = Website.check_login(request)
        return error if error
        
        Global.logger.debug "#{enactor.name} updating account info. New name: #{name}."
        
        if (!enactor.compare_password(pw))
          return { error: t('login.invalid_password') }
        end
        
        if !Login.is_email_valid?(email)
          return { error: t('login.invalid_email_format') }
        end
        enactor.update(login_email: email)
        
        if (!enactor.is_approved?)
          name_validation_msg = Character.check_name(name)
          if (name_validation_msg)
            return { error: name_validation_msg }
          end
          
          taken_error = Login.name_taken?(name, enactor)
          if (taken_error)
            return { error: taken_error }
          end
        
          enactor.update(name: name)
        end
        
        if (!enactor.handle)
          timezone_error = OOCTime.set_timezone(enactor, timezone)
          if (timezone_error)
            return { error: timezone_error }
          end
        end
        
        taken_error = Login.name_taken?(char_alias, enactor)
        if (taken_error) 
          return { error: taken_error }
        end
        name_validation_msg = Character.check_name(char_alias)
        if (taken_error) 
          return { error: name_validation_msg }
        end
        enactor.update(alias: char_alias)
        enactor.update(website_editor: editor)
        
        AresCentral.alts(enactor).each do |alt|
          alt.update(unified_play_screen: unified_play_screen)
          alt.update(website_editor: editor)
        end
        
        {
        }
      end
    end
  end
end