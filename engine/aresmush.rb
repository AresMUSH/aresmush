raise 'Ruby version must be greater than 2.2' unless  RUBY_VERSION.to_f >= 2.2

require 'bundler/setup'
require 'ansi'
require 'yaml'
require 'eventmachine'
require 'active_support/all'
require 'ohm'
require "ohm/json"
require 'i18n'
require "i18n/backend/fallbacks" 
require 'log4r'
require 'log4r/yamlconfigurator'
include Log4r
require 'date'
require 'bcrypt'
require 'rake'
require 'rspec/core/rake_task'
require 'pp'
require 'net/http'
require 'handlebars'
require 'htmlentities'

require 'erubis'
require 'json'
require 'redcarpet'

require 'sinatra/base'
require 'sinatra/cross_origin'
require 'thin'
require 'rubygems'
require 'zip'
require 'sassc'

module AresMUSH
    
  def self.version
    version = File.read(File.join(root_path, "version.txt")) || ""
    version.chomp
  end

  def self.root_path
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end

  def self.plugin_path
    File.join(AresMUSH.root_path, "plugins")
  end

  def self.game_path
    File.join(AresMUSH.root_path, "game")
  end
  
  def self.engine_path
    File.join(AresMUSH.root_path, "engine")
  end

  def self.website_styles_path
    File.join(AresMUSH.game_path, 'styles')
  end

  def self.website_scripts_path
    File.join(AresMUSH.game_path, 'scripts')
  end
  
  def self.website_uploads_path
    File.join(AresMUSH.game_path, 'uploads')
  end
end

require 'aresmush/bootstrapper.rb'
require 'aresmush/client/client_monitor'
require 'aresmush/client/client.rb'
require 'aresmush/client/client_factory.rb'
require 'aresmush/client/client_display_settings.rb'
require 'aresmush/commands/arg_parser.rb'
require 'aresmush/commands/command'
require 'aresmush/commands/command_alias_parser'
require 'aresmush/commands/command_cracker.rb'
require 'aresmush/commands/dispatcher.rb'
require 'aresmush/commands/global_events.rb'
require 'aresmush/config/config_reader'
require 'aresmush/config/help_reader.rb'
require 'aresmush/connection.rb'
require 'aresmush/core_ext/bool_ext.rb'
require 'aresmush/core_ext/string_ext.rb'
require 'aresmush/core_ext/yaml_ext.rb'
require 'aresmush/core_ext/hash_ext.rb'
require 'aresmush/core_ext/match_data_ext.rb'
require 'aresmush/cron.rb'
require 'aresmush/database.rb'
require 'aresmush/db_migrator.rb'
require 'aresmush/engine_notifier.rb'
require 'aresmush/error_block.rb'
require 'aresmush/find_result.rb'
require 'aresmush/global.rb'
require 'aresmush/hash_reader.rb'
require 'aresmush/helpers/class_target_finder.rb'
require 'aresmush/helpers/any_target_finder.rb'
require 'aresmush/helpers/visible_target_finder.rb'
require 'aresmush/helpers/online_char_finder.rb'
require 'aresmush/helpers/on_off_option.rb'
require 'aresmush/http_connector.rb'
require 'aresmush/json_args.rb'
require 'aresmush/locale/locale.rb'
require 'aresmush/locale/locale_loader.rb'
require 'aresmush/logger.rb'
require 'aresmush/markdown_file'
require 'aresmush/models/ohm_callbacks.rb'
require 'aresmush/models/ohm_timestamps.rb'
require 'aresmush/models/ohm_data_types.rb'
require 'aresmush/models/find_by_name.rb'
require 'aresmush/models/object_model.rb'
require 'aresmush/models/role.rb'
require 'aresmush/models/handle.rb'
require 'aresmush/models/character.rb'
require 'aresmush/models/room.rb'
require 'aresmush/models/exit.rb'
require 'aresmush/models/game.rb'
require 'aresmush/models/read_tracker.rb'
require 'aresmush/ohm_ext.rb'
require 'aresmush/plugin/plugin_manager.rb'
require 'aresmush/plugin/command_handler.rb'
require 'aresmush/rest_connector.rb'
require 'aresmush/server.rb'
require 'aresmush/single_result_selector.rb'
require 'aresmush/telnet_negotiation.rb'
require 'aresmush/templates/template_formatters.rb'
require 'aresmush/templates/erb_template_renderer.rb'
require 'aresmush/templates/handlebars_template.rb'
require 'aresmush/web/web_connection.rb'
require 'aresmush/web/engine_api_server.rb'
require 'aresmush/web/web_request.rb'
