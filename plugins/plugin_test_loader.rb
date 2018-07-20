$:.unshift File.join(File.dirname(__FILE__), *%w[.. engine])

puts "Loading plugin test helper."

require "aresmush"

bootstrapper = AresMUSH::Bootstrapper.new
bootstrapper.config_reader.load_game_config
AresMUSH::Global.plugin_manager.load_all

