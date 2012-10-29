#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH

  bootstrapper = Bootstrapper.new

  case ARGV[0]
  when "setup"
    bootstrapper.command_line.setup
  when "migrate"
    bootstrapper.command_line.migrate
  when "start"
    bootstrapper.command_line.start
  else
    puts "Usage: aresmush <command> <options>\n"
    puts "\nAvailable commands:"
    puts "   (TODO) setup - Walks through the setup process.  *Do this first.*"
    puts "   start - Starts the MUSH server."
  end

end

