#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  bootstrapper = Bootstrapper.new

  case ARGV[0]
  when "setup"
    bootstrapper.client.setup
  when "start"
    bootstrapper.client.start
  else
    puts "Usage: aresmush <command> <options>\n"
    puts "\nAvailable commands:"
    puts "   (TODO) setup - Walks through the setup process.  *Do this first.*"
    puts "   start - Starts the MUSH server."
  end

end

