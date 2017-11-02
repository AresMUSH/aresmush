module AresMUSH
  
  def self.version
    File.read(File.join(game_path, "version.txt"))
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
  
  def self.website_path
    File.join(AresMUSH.root_path, 'website')
  end
  
  def self.website_public_path
    AresMUSH.game_path
  end

  def self.website_views_path
    File.join(AresMUSH.website_path, 'views')
  end
  
  def self.website_files_path
    File.join(AresMUSH.website_public_path, 'files')
  end

  def self.website_theme_image_path
    File.join(AresMUSH.website_public_path, 'theme_images')
  end
  
  def self.website_scripts_path
    File.join(AresMUSH.website_public_path, 'scripts')
  end
  
  
end

raise 'Ruby version must be greater than 2.2' unless  RUBY_VERSION.to_f >= 2.2

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

require 'aresmush/config/config_reader'
require 'aresmush/config/help_reader.rb'
require 'aresmush/core_ext/bool_ext.rb'
require 'aresmush/core_ext/string_ext.rb'
require 'aresmush/core_ext/yaml_ext.rb'
require 'aresmush/core_ext/hash_ext.rb'
require 'aresmush/core_ext/match_data_ext.rb'
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