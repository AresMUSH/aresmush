module AresMUSH
  module Website
    class DeployWebsiteRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        Global.dispatcher.spawn("Deploying website", nil) do
          install_path = Global.read_config('website', 'website_code_path')
          path = File.join( install_path, "bin", "deploy" )
          output = `#{path} #{install_path} 2>&1`
        
          Global.logger.info "Deployed web portal: #{output}"
        end
        
        { }
      end
    end
  end
end