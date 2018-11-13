release_version = ARGV[0]

if (!release_version)
  puts "USAGE:  release <version>  (e.g. 1.0)"
  exit
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[engine]))

require 'fileutils'
require 'aresmush'


File.open('version.txt', 'w') do |file|
  file.puts release_version
end

File.open(File.join('..', 'ares-webportal', 'public', 'scripts', 'aresweb_version.js'), 'w') do |file|
  file.puts "var aresweb_version = \"#{release_version}\";"
end


dest = File.join(AresMUSH.root_path, 'install', 'game.distr')

FileUtils.cp_r File.join(AresMUSH.game_path, 'config'), dest
FileUtils.cp_r File.join(AresMUSH.game_path, 'styles'), dest
FileUtils.cp_r File.join(AresMUSH.game_path, 'text'), dest
FileUtils.cp_r File.join(AresMUSH.game_path, 'uploads', 'theme_images'), File.join(dest, 'uploads')