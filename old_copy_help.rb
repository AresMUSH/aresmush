help_version = ARGV[0]

if (!help_version)
  puts "USAGE:  copy_help <version>  (e.g. 1.0)"
  exit
end

filename_friendly_help_version = help_version.gsub(".", "-")

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[engine]))

require 'fileutils'
require 'ansi'
require 'aresmush'
require 'erubis'
require 'rspec'
require 'rspec/core/rake_task'
require 'tempfile'
#require 'mongoid'
require_relative 'install/init_db.rb'
require_relative 'install/configure_game.rb'
require_relative 'plugins/help/helpers.rb'

def minimal_boot
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.config_reader.load_game_config
  AresMUSH::Global.plugin_manager.load_all
  bootstrapper.help_reader.load_game_help
  bootstrapper.db.load_config
end


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

def format_help(msg, filename_friendly_help_version)
    # Take escaped backslashes out of the equation for a moment because
    # they throw the other formatters off.
    msg = msg.gsub(/%\\/, "~ESCBS~")

    # Do substitutions
    msg = AresMUSH::SubstitutionFormatter.format(msg, false)

    # Replace TOC 
    msg = msg.gsub("[[toc]]", "{% include toc.html %}")
    
    # Unescape %'s
    msg = msg.gsub("\\%", "%")

    # Put the escaped backslashes back in.
    msg = msg.gsub("~ESCBS~", "\\")

    if (msg =~ /\]\(\/help\/([^\)]+)\)/)
      match = $1
      topic_name = AresMUSH::Help.find_topic(match).first
      topic = AresMUSH::Help.topic_index[topic_name]
      if (!topic)
        raise "Can't find topic #{match} in #{msg}"
      end
      
      msg = msg.gsub(/\]\(\/help\/([^\)]+)\)/, "](/help/#{filename_friendly_help_version}/#{topic['plugin']}/#{topic['topic']})")
    end
    msg
end

minimal_boot


help_dir = "/Users/lynn/Documents/ares-docs/help/#{filename_friendly_help_version}"
if (!Dir.exist?(help_dir))
  Dir.mkdir help_dir
end


plugins = Dir['plugins/*']
plugin_names = []

plugins.each do |p|
  next if !File.directory?(p)
  plugin_name = File.basename(p)
  plugin_help_dir = "#{help_dir}/#{plugin_name}"

  help_files = Dir["#{p}/help/en/*.md"]
  next if help_files.empty?

  plugin_names << plugin_name
  if (!Dir.exist?(plugin_help_dir))
    Dir.mkdir plugin_help_dir
  end
  
  puts "Processing #{p}..."
  help_files.each do |h|
    orig = File.readlines h
    orig.shift
    orig.unshift "version: #{help_version}\n"
    orig.unshift "layout: help_#{filename_friendly_help_version}\n"
    orig.unshift "---\n"
    
    new_filename =  "#{plugin_help_dir}/#{File.basename(h)}"
    
    puts "Copying files from #{h} to #{new_filename}"
    File.open(new_filename, 'w') do |f|
      new_lines = orig.map { |o| format_help(o, filename_friendly_help_version)}
      f.write new_lines.join
    end
  end
end


toc_topics = {}

AresMUSH::Help.toc.keys.sort.each do |toc|
  toc_topics[toc] = AresMUSH::Help.toc_section_topic_data(toc)
end


File.open("/Users/lynn/Documents/ares-docs/_includes/help_#{filename_friendly_help_version}.md", 'w') do |file|
  file.puts "*AresMUSH version #{help_version}*"
  file.puts "\n[Version #{help_version} Home](/help/#{filename_friendly_help_version}/)"
  
  toc_topics.each do |toc, topics|
    file.puts ""
    file.puts "## #{toc}"
    file.puts ""
    
    topics.select { |name, data| data['tutorial'] }.sort_by { |name, data| [data['order'] || 99, name] }.each do |name, data|
      file.puts "* [#{name.humanize}](/help/#{filename_friendly_help_version}/#{data['plugin']}/#{data['topic']})"
    end

    file.puts "\n*Commands*: "
    topics.select { |name, data| !data['tutorial'] }.sort_by { |name, data| [data['order'] || 99, name] }.each do |name, data|
        file.puts "[#{name.titleize}](/help/#{filename_friendly_help_version}/#{data['plugin']}/#{data['topic']})"
    end
  end
  
end


File.open("#{help_dir}/index.md", 'w') do |file|
  file.puts "---"
  file.puts "title: Help Archive - Version #{help_version}"
  file.puts "description: Online help archive."
  file.puts "layout: page"
  file.puts "tags:"
  file.puts "- help-#{help_version}"
  file.puts "---"
  file.puts ""
  file.puts "This is an archive of the AresMUSH online help.  For other versions, see the [Plugins](/plugins) page."
  file.puts ""
  file.puts "{% include help_#{filename_friendly_help_version}.md %}"
end