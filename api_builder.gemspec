Gem::Specification.new do |s|
  s.name = "api_builder"
  s.version = "1.0.2"

  s.author = "Lasse Bunk"
  s.email = "lassebunk@gmail.com"
  s.description = "ApiBuilder is a Ruby on Rails template engine that allows for multiple formats being laid out in a single specification, currently XML and JSON."
  s.summary = "Multiple API formats from a single specification."
  s.homepage = "http://github.com/lassebunk/api_builder"
  
  s.files = Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
end