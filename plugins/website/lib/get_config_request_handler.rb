module AresMUSH
  module Website
    class GetConfigRequestHandler
      def handle(request)
        section = request.args[:section]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        if (section)
          config = {}
          Global.read_config(section).sort.each do |k, v|
            config[k] = { key: k, value: v, new_value: v }
          end
          { section: section, config: config }
        else
          Global.config_reader.config.sort.map { |k, v| { section: k } }
        end
      end
    end
  end
end