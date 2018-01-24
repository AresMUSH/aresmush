module AresMUSH
  module Website
    class GetTinkerRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end

        text = File.read(File.join(AresMUSH.plugin_path, 'tinker', 'engine', 'tinker_cmd.rb'))
        default = File.read(File.join(AresMUSH.plugin_path, 'tinker', 'default_tinker.txt'))
        
        {
          text:  text,
          default: default
        }
      end
    end
  end
end