module AresMUSH
  module Utils
    class GameConfigValidator
      attr_accessor :error_list
      
      def initialize
        self.error_list = []
      end
      
      def validate
        check_backup
        check_game
        check_datetime
        check_plugins
        check_server
        check_sites
        check_skin
        check_names
        
        self.error_list
      end
      
      def check_backup
        validator = Manage::ConfigValidator.new("backup")
        validator.check_cron('backup_cron')
        validator.require_in_list('backup_type', [ 'aws', 'local' ])
        validator.require_int('backups_to_keep', 1)
        self.error_list.concat(validator.errors)
      end
      
      def check_game
        validator = Manage::ConfigValidator.new("game")
        validator.require_nonblank_text('category')
        validator.require_nonblank_text('description')
        validator.require_nonblank_text('name')
        validator.require_boolean('public_game')
        validator.require_nonblank_text('status')
        validator.require_text('website')
        self.error_list.concat(validator.errors)
      end
      
      def check_datetime
        validator = Manage::ConfigValidator.new("datetime")
        validator.require_nonblank_text('date_and_time_entry_format_help')
        validator.require_nonblank_text('date_entry_format_help')
        validator.require_nonblank_text('long_date_format')
        validator.require_nonblank_text('server_timezone')
        validator.require_nonblank_text('short_date_format')
        validator.require_nonblank_text('time_format')
        self.error_list.concat(validator.errors)
      end
      
      def check_plugins
        validator = Manage::ConfigValidator.new("plugins")
        validator.require_list('disabled_plugins')
        validator.require_list('extras')
        validator.require_list('optional_plugins')
        validator.require_hash('config_help_links')
        self.error_list.concat(validator.errors)
      end
      
      def check_server
        validator = Manage::ConfigValidator.new("server")
        validator.require_int('engine_api_port')
        validator.require_int('web_portal_port')
        validator.require_int('websocket_port')
        validator.require_int('port')
        validator.require_text('bind_address')
        validator.require_text('certificate_file_path')
        validator.require_text('private_key_file_path')
        validator.require_nonblank_text('hostname')
        validator.require_boolean('use_https')
        self.error_list.concat(validator.errors)
      end
      
      def check_sites
        validator = Manage::ConfigValidator.new("sites")
        validator.require_list('suspect')
        validator.require_boolean('ban_proxies')
        self.error_list.concat(validator.errors)
      end
      
      def check_skin
        validator = Manage::ConfigValidator.new("skin")
        validator.require_text('divider')
        validator.require_text('footer')
        validator.require_text('header')
        validator.require_hash('line_with_text')
        validator.require_text('plain')
        validator.require_list('random_colors')
        self.error_list.concat(validator.errors)
      end
      
      def check_names
        validator = Manage::ConfigValidator.new("names")
        validator.require_list('restricted')        
        self.error_list.concat(validator.errors)
      end
      
    end
  end
end