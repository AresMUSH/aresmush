module AresMUSH
  module Global
    def self.read_config(x, y)
    end
  end
end

require 'fileutils'
require 'ansi'
require_relative 'lib/aresmush/formatters/line.rb'
require_relative 'lib/aresmush/formatters/ansi_formatter.rb'
require_relative 'lib/aresmush/formatters/client_formatter.rb'
require_relative 'lib/aresmush/formatters/substitution_formatter.rb'

class String
  def titlecase
    self.downcase.strip.gsub(/\b('?[a-z])/) { $1.capitalize }
  end   
end

def plugin_title(name)
  return "AresCentral" if name == "arescentral"
  return "IC Time" if name == "ictime"
  return "OOC Time" if name == "ooctime"
  return "FS3 Skills" if name == "fs3skills"
  return "FS3 Combat" if name == "fs3combat"
  
  name.titlecase
end

def format_help(msg)
    # Take escaped backslashes out of the equation for a moment because
    # they throw the other formatters off.
    msg = msg.gsub(/%\\/, "~ESCBS~")

    # Do substitutions
    msg = AresMUSH::SubstitutionFormatter.format(msg, false)

    # Unescape %'s
    msg = msg.gsub("\\%", "%")

    # Put the escaped backslashes back in.
    msg = msg.gsub("~ESCBS~", "\\")

    msg
end

version = File.readlines("game/version.txt").join

plugins = Dir['game/plugins/*']
plugin_names = []
plugins.each do |p|
  next if !File.directory?(p)
  plugin_name = File.basename(p)
  help_dir = "/Users/lynn/Documents/ares/help/#{plugin_name}"
  plugin_names << plugin_name
  if (!Dir.exist?(help_dir))
    Dir.mkdir help_dir
  end
  help_files = Dir["#{p}/help/*.md"]
  help_files.each do |h|
    orig = File.readlines h
    new_filename =  "#{help_dir}/#{File.basename(h)}"
    File.open(new_filename, 'w') do |f|
      new_lines = orig.map { |o| format_help(o)}
      f.write new_lines.join
    end
  end
end


File.open("/Users/lynn/Documents/ares/ares/partials/plugin_list.md", 'w') do |file|
  file.puts "*AresMUSH version #{version}*"
  file.puts ""
  plugin_names.each do |p|
    file.puts "* [#{plugin_title(p)}](/help/#{p})"
  end
end
