module AresMUSH
  module Manage
    class ThemeInstallCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle        
        begin
          client.emit_ooc t('manage.starting_them_install')
          url = "https://github.com/AresMUSH/ares-extras/tree/master/themes/#{self.name}"
          importer = AresMUSH::Manage::ThemeImporter.new(self.name)
          importer.import
          Website.rebuild_css
          client.emit_success t('manage.theme_installed', :name => self.name, :url => url)
        rescue Exception => e
          Global.logger.debug "Error instaling theme: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_installing_theme', :name => self.name, :error => e)
        end
      end
    end
  end
end
