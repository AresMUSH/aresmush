require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'

bootstrapper = AresMUSH::Bootstrapper.new
AresMUSH::Global.plugin_manager.load_all
bootstrapper.config_reader.load_game_config
bootstrapper.db.load_config

webserver_port = AresMUSH::Global.read_config("server", "webserver_port")
web = AresMUSH::WebAppLoader.new
web.run(port: webserver_port)