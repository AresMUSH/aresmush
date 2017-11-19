require 'rubygems'
require 'bundler'

Bundler.require

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'website'))

require 'sinatra/base'
require 'thin'
require "sinatra/reloader"
require 'sinatra/flash'
require 'compass'
require 'redis-rack'
require 'diff/lcs'

require 'aresmush'

require 'web_server.rb'
require 'web_bootstrapper.rb'
require 'web_notifier.rb'
require 'engine_api_connector.rb'

bootstrapper = AresMUSH::WebBootstrapper.new
bootstrapper.start

run AresMUSH::WebApp