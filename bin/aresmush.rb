#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

client = AresMUSH::Client.new

case ARGV[0]
  when "setup"
    client.setup
  when "start"
    client.start
  else
    puts "Usage: aresmush <command> <options>\n"
    puts "\nAvailable commands:"
    puts "   setup - Walks through the setup process.  *Do this first.*"
    puts "   start - Starts the MUSH server."
end

