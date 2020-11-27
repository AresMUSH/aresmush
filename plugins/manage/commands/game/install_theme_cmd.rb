module AresMUSH
  module Manage
    class ThemeInstallCmd
      include CommandHandler
      
      attr_accessor :url
      
      def parse_args
        self.url = downcase_arg(cmd.args)
      end
      
      def required_args
        [ self.url ]
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle        
        begin
          client.emit_ooc t('manage.starting_them_install')
          if (self.url == 'default')
            readme = "https://aresmush.com/tutorials/config/website.html"
          else
            readme = url
          end
          importer = AresMUSH::Manage::ThemeImporter.new(self.url)
          importer.import
          Website.rebuild_css
          client.emit_success t('manage.theme_installed', :url => readme)
        rescue Exception => e
          Global.logger.debug "Error instaling theme: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_installing_theme', :url => self.url, :error => e)
        end
      end
    end
  end
end
