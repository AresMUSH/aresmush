module AresMUSH
  module Website
    class SetupIndexRequestHandler
      def handle(request)
        file = request.args[:file]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        textfiles = Dir[File.join(AresMUSH.game_path, 'text', '**')]
        textfiles = textfiles.select { |f| File.basename(f) != "blacklist.txt" }.sort.map { |f| { name: File.basename(f), file_type: 'text' }}
        textfiles << { name: 'colors.scss', file_type: 'style' }
        textfiles << { name: 'custom_style.scss', file_type: 'style' }
        
        {
          config: ConfigReader.config_files.sort.map { |f| { name: File.basename(f) } },
          textfiles: textfiles
        }
        
      end
    end
  end
end