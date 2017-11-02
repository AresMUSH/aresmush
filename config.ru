require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'engine'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'website'))

require 'aresmush'
require 'engine'
require 'website'

webserver_log = File.join(AresMUSH.game_path, "logs", "webserver.log")
if (File.size(webserver_log) > 100000)
  lines = File.readlines(webserver_log)
  File.open(webserver_log, "w+") { |f| f.write lines[lines.count / 2, -1]}
end

bootstrapper = AresMUSH::Bootstrapper.new
bootstrapper.web_start

webserver_port = AresMUSH::Global.read_config("server", "webserver_port")
#web = AresMUSH::WebAppLoader.new
#web.run(port: webserver_port)
run AresMUSH::WebApp