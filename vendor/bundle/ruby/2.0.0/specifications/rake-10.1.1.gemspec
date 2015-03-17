# -*- encoding: utf-8 -*-
# stub: rake 10.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rake"
  s.version = "10.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.2") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jim Weirich"]
  s.date = "2013-12-20"
  s.description = "Rake is a Make-like program implemented in Ruby. Tasks and dependencies arespecified in standard Ruby syntax."
  s.email = "jim.weirich@gmail.com"
  s.executables = ["rake"]
  s.extra_rdoc_files = ["README.rdoc", "MIT-LICENSE", "TODO", "CHANGES", "doc/command_line_usage.rdoc", "doc/glossary.rdoc", "doc/proto_rake.rdoc", "doc/rakefile.rdoc", "doc/rational.rdoc", "doc/release_notes/rake-0.4.14.rdoc", "doc/release_notes/rake-0.4.15.rdoc", "doc/release_notes/rake-0.5.0.rdoc", "doc/release_notes/rake-0.5.3.rdoc", "doc/release_notes/rake-0.5.4.rdoc", "doc/release_notes/rake-0.6.0.rdoc", "doc/release_notes/rake-0.7.0.rdoc", "doc/release_notes/rake-0.7.1.rdoc", "doc/release_notes/rake-0.7.2.rdoc", "doc/release_notes/rake-0.7.3.rdoc", "doc/release_notes/rake-0.8.0.rdoc", "doc/release_notes/rake-0.8.2.rdoc", "doc/release_notes/rake-0.8.3.rdoc", "doc/release_notes/rake-0.8.4.rdoc", "doc/release_notes/rake-0.8.5.rdoc", "doc/release_notes/rake-0.8.6.rdoc", "doc/release_notes/rake-0.8.7.rdoc", "doc/release_notes/rake-0.9.0.rdoc", "doc/release_notes/rake-0.9.1.rdoc", "doc/release_notes/rake-0.9.2.2.rdoc", "doc/release_notes/rake-0.9.2.rdoc", "doc/release_notes/rake-0.9.3.rdoc", "doc/release_notes/rake-0.9.4.rdoc", "doc/release_notes/rake-0.9.5.rdoc", "doc/release_notes/rake-0.9.6.rdoc", "doc/release_notes/rake-10.0.0.rdoc", "doc/release_notes/rake-10.0.1.rdoc", "doc/release_notes/rake-10.0.2.rdoc", "doc/release_notes/rake-10.0.3.rdoc", "doc/release_notes/rake-10.1.0.rdoc"]
  s.files = ["CHANGES", "MIT-LICENSE", "README.rdoc", "TODO", "bin/rake", "doc/command_line_usage.rdoc", "doc/glossary.rdoc", "doc/proto_rake.rdoc", "doc/rakefile.rdoc", "doc/rational.rdoc", "doc/release_notes/rake-0.4.14.rdoc", "doc/release_notes/rake-0.4.15.rdoc", "doc/release_notes/rake-0.5.0.rdoc", "doc/release_notes/rake-0.5.3.rdoc", "doc/release_notes/rake-0.5.4.rdoc", "doc/release_notes/rake-0.6.0.rdoc", "doc/release_notes/rake-0.7.0.rdoc", "doc/release_notes/rake-0.7.1.rdoc", "doc/release_notes/rake-0.7.2.rdoc", "doc/release_notes/rake-0.7.3.rdoc", "doc/release_notes/rake-0.8.0.rdoc", "doc/release_notes/rake-0.8.2.rdoc", "doc/release_notes/rake-0.8.3.rdoc", "doc/release_notes/rake-0.8.4.rdoc", "doc/release_notes/rake-0.8.5.rdoc", "doc/release_notes/rake-0.8.6.rdoc", "doc/release_notes/rake-0.8.7.rdoc", "doc/release_notes/rake-0.9.0.rdoc", "doc/release_notes/rake-0.9.1.rdoc", "doc/release_notes/rake-0.9.2.2.rdoc", "doc/release_notes/rake-0.9.2.rdoc", "doc/release_notes/rake-0.9.3.rdoc", "doc/release_notes/rake-0.9.4.rdoc", "doc/release_notes/rake-0.9.5.rdoc", "doc/release_notes/rake-0.9.6.rdoc", "doc/release_notes/rake-10.0.0.rdoc", "doc/release_notes/rake-10.0.1.rdoc", "doc/release_notes/rake-10.0.2.rdoc", "doc/release_notes/rake-10.0.3.rdoc", "doc/release_notes/rake-10.1.0.rdoc"]
  s.homepage = "http://github.com/jimweirich/rake"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--line-numbers", "--show-hash", "--main", "README.rdoc", "--title", "Rake -- Ruby Make"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = "2.4.6"
  s.summary = "Ruby based make-like utility."

  s.installed_by_version = "2.4.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 2.1"])
    else
      s.add_dependency(%q<minitest>, ["~> 2.1"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 2.1"])
  end
end
