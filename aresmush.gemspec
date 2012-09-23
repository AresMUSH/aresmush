Gem::Specification.new do |s|
  s.name        = 'aresmush'
  s.version     = '0.0.1'
  s.summary     = "AresMUSH MUSH server."
  s.description = "A new breed of MUSHes."
  s.authors     = ["lynnfaraday@github"]
  s.files       = Dir.glob("{bin,lib,spec}/**/*")
  s.homepage    = 'http://github.com/lynnfaraday/aresmush'
  s.platform    = Gem::Platform::RUBY
#  s.add_runtime_dependency "flickraw", '~> 0.9'
  s.executables = "aresmush"
end