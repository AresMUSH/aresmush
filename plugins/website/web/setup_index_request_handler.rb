module AresMUSH
  module Website
    class SetupIndexRequestHandler
      def handle(request)
        file = request.args['file']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        textfiles = Dir[File.join(AresMUSH.game_path, 'text', '**')]
        textfiles = textfiles.select { |f| File.basename(f) != "blacklist.txt" }.sort.map { |f| { name: File.basename(f), file_type: 'text' }}
        textfiles << { name: 'colors.scss', file_type: 'style' }
        textfiles << { name: 'custom_style.scss', file_type: 'style' }
        textfiles << { name: 'rainbow.scss', file_type: 'style' }
        textfiles << { name: 'fonts.scss', file_type: 'style' }
                
        codefiles = []
        Website.editable_code_files.each do |section|
          codefiles << {
            name: section[:name],
            help: section[:help],
            files: section[:files].keys
          }
        end
        
        {
          config: ConfigReader.config_files.sort.map { |f| { name: File.basename(f) } },
          textfiles: textfiles,
          codefiles: codefiles
        }
        
      end
    end
  end
end