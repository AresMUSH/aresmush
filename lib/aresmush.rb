module AresMUSH
  def self.game_path
    File.expand_path(File.join(File.dirname(__FILE__), "..", "game"))
  end
end

require 'aresmush/command_line'
require 'aresmush/bootstrapper'
require 'aresmush/config_reader'
require 'aresmush/client_monitor'
require 'aresmush/command'
require 'aresmush/core_ext/string_ext.rb'
require 'aresmush/core_ext/yaml_ext.rb'
require 'aresmush/core_ext/hash_ext.rb'
require 'aresmush/core_ext/match_data_ext.rb'
require 'aresmush/client.rb'
require 'aresmush/client_greeter.rb'
require 'aresmush/connection.rb'
require 'aresmush/server.rb'
require 'aresmush/locale/locale.rb'
require 'aresmush/locale/locale_loader.rb'
require 'aresmush/plugin/plugin_manager.rb'
require 'aresmush/plugin/plugin_factory.rb'
require 'aresmush/plugin/plugin.rb'
require 'aresmush/container.rb'
require 'aresmush/dispatcher.rb'
require 'aresmush/logger.rb'
require 'aresmush/database.rb'
require 'aresmush/models/ares_model.rb'
require 'aresmush/models/player.rb'
require 'aresmush/models/room.rb'
require 'aresmush/models/exit.rb'
require 'aresmush/models/game.rb'
require 'aresmush/formatter.rb'