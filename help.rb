require 'fileutils'


help_files = Dir["plugins/**/help/en/*.md"]
help_files.each do |h|
  FileUtils.copy h, "help/#{File.basename(h)}"
end
