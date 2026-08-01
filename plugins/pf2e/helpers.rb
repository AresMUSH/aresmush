# Thin loader for all Pf2e helper modules.
# Each file under helpers/ reopens AresMUSH::Pf2e and adds methods.
# Load order is alphabetical; name files so dependencies come first if needed.

Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].sort.each do |file|
  require file
end
