#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *%w[lib])

require "aresmush"

module AresMUSH
  
bootstrapper = Bootstrapper.new
bootstrapper.command_line.start

end