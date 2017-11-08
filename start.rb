#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *%w[engine])

require "aresmush"

module AresMUSH
  
bootstrapper = EngineBootstrapper.new
bootstrapper.command_line.start

end