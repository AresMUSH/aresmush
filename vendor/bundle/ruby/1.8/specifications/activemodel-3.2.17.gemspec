# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{activemodel}
  s.version = "3.2.17"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.date = %q{2014-02-17}
  s.description = %q{A toolkit for building modeling frameworks like Active Record and Active Resource. Rich support for attributes, callbacks, validations, observers, serialization, internationalization, and testing.}
  s.email = %q{david@loudthinking.com}
  s.files = ["CHANGELOG.md", "MIT-LICENSE", "README.rdoc", "lib/active_model/attribute_methods.rb", "lib/active_model/callbacks.rb", "lib/active_model/conversion.rb", "lib/active_model/dirty.rb", "lib/active_model/errors.rb", "lib/active_model/lint.rb", "lib/active_model/locale/en.yml", "lib/active_model/mass_assignment_security/permission_set.rb", "lib/active_model/mass_assignment_security/sanitizer.rb", "lib/active_model/mass_assignment_security.rb", "lib/active_model/naming.rb", "lib/active_model/observer_array.rb", "lib/active_model/observing.rb", "lib/active_model/railtie.rb", "lib/active_model/secure_password.rb", "lib/active_model/serialization.rb", "lib/active_model/serializers/json.rb", "lib/active_model/serializers/xml.rb", "lib/active_model/test_case.rb", "lib/active_model/translation.rb", "lib/active_model/validations/acceptance.rb", "lib/active_model/validations/callbacks.rb", "lib/active_model/validations/confirmation.rb", "lib/active_model/validations/exclusion.rb", "lib/active_model/validations/format.rb", "lib/active_model/validations/inclusion.rb", "lib/active_model/validations/length.rb", "lib/active_model/validations/numericality.rb", "lib/active_model/validations/presence.rb", "lib/active_model/validations/validates.rb", "lib/active_model/validations/with.rb", "lib/active_model/validations.rb", "lib/active_model/validator.rb", "lib/active_model/version.rb", "lib/active_model.rb"]
  s.homepage = %q{http://www.rubyonrails.org}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A toolkit for building modeling frameworks (part of Rails).}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["= 3.2.17"])
      s.add_runtime_dependency(%q<builder>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<activesupport>, ["= 3.2.17"])
      s.add_dependency(%q<builder>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<activesupport>, ["= 3.2.17"])
    s.add_dependency(%q<builder>, ["~> 3.0.0"])
  end
end
