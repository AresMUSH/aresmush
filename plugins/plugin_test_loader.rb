require "aresmush"

bootstrapper = AresMUSH::Bootstrapper.new
bootstrapper.config_reader.load_game_config
AresMUSH::Global.plugin_manager.load_all

