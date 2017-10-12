module AresMUSH
  def self.game_path
    File.expand_path(File.join(File.dirname(__FILE__), "..", "game"))
  end
  
  def self.version
    File.read(File.join(game_path, "version.txt"))
  end
  
  def self.root_path
    File.expand_path(File.join(File.dirname(__FILE__), ".."))
  end
  
end

raise 'Ruby version must be greater than 2.0' unless  RUBY_VERSION.to_f >= 2.0

# Require this before all other items
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
require 'html2markdown'

require 'sinatra/base'
require "sinatra/reloader"
require 'sinatra/flash'
require 'thin'
require 'compass'
require 'redis-rack'

require 'erubis'
require 'json'
require 'redcarpet'


require 'aresmush/bootstrapper'
require 'aresmush/client/client_monitor'
require 'aresmush/client/client.rb'
require 'aresmush/client/client_factory.rb'
require 'aresmush/client/client_greeter.rb'
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
require 'aresmush/error_block.rb'
require 'aresmush/formatters/ansi_formatter.rb'
require 'aresmush/formatters/client_formatter.rb'
require 'aresmush/formatters/input_formatter.rb'
require 'aresmush/formatters/time_formatter.rb'
require 'aresmush/formatters/line.rb'
require 'aresmush/formatters/markdown_formatter.rb'
require 'aresmush/formatters/paginator.rb'
require 'aresmush/formatters/pose_formatter.rb'
require 'aresmush/formatters/progress_bar_formatter.rb'
require 'aresmush/formatters/random_colorizer.rb'
require 'aresmush/formatters/substitution_formatter.rb'
require 'aresmush/global.rb'
require 'aresmush/hash_reader.rb'
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
require 'aresmush/plugin/plugin_manager.rb'
require 'aresmush/plugin/command_handler.rb'
require 'aresmush/plugin_helpers/find_result.rb'
require 'aresmush/plugin_helpers/single_result_selector.rb'
require 'aresmush/plugin_helpers/class_target_finder.rb'
require 'aresmush/plugin_helpers/any_target_finder.rb'
require 'aresmush/plugin_helpers/visible_target_finder.rb'
require 'aresmush/plugin_helpers/online_char_finder.rb'
require 'aresmush/plugin_helpers/on_off_option.rb'
require 'aresmush/rest_connector.rb'
require 'aresmush/templates/template_formatters.rb'
require 'aresmush/templates/template_renderer.rb'
require 'aresmush/server.rb'
require 'aresmush/telnet_negotiation.rb'
require 'aresmush/web/web_server.rb'
require 'aresmush/web/web_connection.rb'
