module AresMUSH
  module Website
    class GetTinkerRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_coder?)
          return { error: t('dispatcher.not_allowed') }
        end

        text = File.read(File.join(AresMUSH.plugin_path, 'tinker', 'commands', 'tinker_cmd.rb'))
        default = File.read(File.join(AresMUSH.plugin_path, 'tinker', 'default_tinker.txt'))
        
        {
          text:  text,
          default: default
        }
      end
    end
  end
end