# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{nimo}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["moonpxi"]
  s.date = %q{2009-06-03}
  s.email = %q{paulo.schneider@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/nimo.rb",
     "spec/nimo_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/moonpxi/nimo}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Ruby game development library using Gosu.}
  s.test_files = [
    "spec/nimo_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
