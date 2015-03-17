# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{multi_json}
  s.version = "1.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Bleigh", "Josh Kalderimis", "Erik Michaels-Ober", "Pavel Pravosud"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDcDCCAligAwIBAgIBATANBgkqhkiG9w0BAQUFADA/MQ4wDAYDVQQDDAVwYXZl\nbDEYMBYGCgmSJomT8ixkARkWCHByYXZvc3VkMRMwEQYKCZImiZPyLGQBGRYDY29t\nMB4XDTEzMDgxMTE1NDYzNVoXDTE0MDgxMTE1NDYzNVowPzEOMAwGA1UEAwwFcGF2\nZWwxGDAWBgoJkiaJk/IsZAEZFghwcmF2b3N1ZDETMBEGCgmSJomT8ixkARkWA2Nv\nbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAO8/eRkT0QewaGvJ4nnV\nPejBZ50kVhQIQAdc+fdp4JyQX4Nn1FdxMe2q7BGYtSmdCLNnqO//m/HRzAyjIN5O\ntYRcODPI4gCSJR2wlS72+PJvZv8m0FHnzO5BeQ2w5UcGifyaR/A/xOx1oFnNcDMB\nN6yIOV7IcQrz1OaGwdr7r+1D4Y0ZM0bCJVq882UNsqlnLC3tHGMNsPEj+dgrysWp\nc7XRxH+LZHfPVYy2JQ+DmAFZE8yjuRe/BgsAe59j7Zxtxu62BrLk2yWp44YZF0Gx\nnwJh83W7cSmNDGKy72tIsuUAqSUunp3rJ2zkgkY3G9lFQHqIzxQJxdq8Ir0GFlUo\nW6cCAwEAAaN3MHUwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0OBBYEFDti\n+zDBnPhm+3PsLqXqlFWuxiCsMB0GA1UdEQQWMBSBEnBhdmVsQHByYXZvc3VkLmNv\nbTAdBgNVHRIEFjAUgRJwYXZlbEBwcmF2b3N1ZC5jb20wDQYJKoZIhvcNAQEFBQAD\nggEBAC/fDN75QBrn+A5ERo9qlMd1DcAC3UNvjnWpHvRTva2I1PxIg2zEJphOimDo\nhEvmruC3urPpMwEuAsRfyL6+5SRBnAfLP4Yu7SFYuMRtnZvIYVUgUmxoteISbm7g\nFPXe8v3M5aYJ1e/VM11G+2ZwXsAx/rH4kaAhFBMQadrnamluFHX+tdTVCbEwZW/5\nNrgsYshJ0qFLYhfktlApOAisrXZskGYAeUQSWVu5nzqQlQ3+wXNsPtATuZNtvUaB\n7BTxdlSpJZDcAK29Ni3NRCRu6Air4wfDln0Ilzeuut6cJ4/j2/RlvsccVSRaEfOa\nwM7GTK5SEdU3qelyBdc4+RRs6uU=\n-----END CERTIFICATE-----\n"]
  s.date = %q{2014-03-19}
  s.description = %q{A common interface to multiple JSON libraries, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, NSJSONSerialization, gson.rb, JrJackson, and OkJson.}
  s.email = ["michael@intridea.com", "josh.kalderimis@gmail.com", "sferik@gmail.com"]
  s.files = [".document", ".rspec", ".travis.yml", ".yardopts", "CHANGELOG.md", "CONTRIBUTING.md", "Gemfile", "LICENSE.md", "README.md", "Rakefile", "lib/multi_json.rb", "lib/multi_json/adapter.rb", "lib/multi_json/adapter_error.rb", "lib/multi_json/adapters/gson.rb", "lib/multi_json/adapters/jr_jackson.rb", "lib/multi_json/adapters/json_common.rb", "lib/multi_json/adapters/json_gem.rb", "lib/multi_json/adapters/json_pure.rb", "lib/multi_json/adapters/nsjsonserialization.rb", "lib/multi_json/adapters/oj.rb", "lib/multi_json/adapters/ok_json.rb", "lib/multi_json/adapters/yajl.rb", "lib/multi_json/convertible_hash_keys.rb", "lib/multi_json/options.rb", "lib/multi_json/parse_error.rb", "lib/multi_json/vendor/okjson.rb", "lib/multi_json/version.rb", "multi_json.gemspec", "spec/gson_adapter_spec.rb", "spec/jr_jackson_adapter_spec.rb", "spec/json_gem_adapter_spec.rb", "spec/json_pure_adapter_spec.rb", "spec/multi_json_spec.rb", "spec/nsjsonserialization_adapter_spec.rb", "spec/oj_adapter_spec.rb", "spec/ok_json_adapter_spec.rb", "spec/shared/adapter.rb", "spec/shared/json_common_adapter.rb", "spec/shared/options.rb", "spec/spec_helper.rb", "spec/yajl_adapter_spec.rb"]
  s.homepage = %q{http://github.com/intridea/multi_json}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A common interface to multiple JSON libraries.}
  s.test_files = ["spec/gson_adapter_spec.rb", "spec/jr_jackson_adapter_spec.rb", "spec/json_gem_adapter_spec.rb", "spec/json_pure_adapter_spec.rb", "spec/multi_json_spec.rb", "spec/nsjsonserialization_adapter_spec.rb", "spec/oj_adapter_spec.rb", "spec/ok_json_adapter_spec.rb", "spec/shared/adapter.rb", "spec/shared/json_common_adapter.rb", "spec/shared/options.rb", "spec/spec_helper.rb", "spec/yajl_adapter_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
  end
end
