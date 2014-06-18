Gem::Specification.new do |s|
  s.name        = 'emojidex-vectors'
  s.version     = '1.0.1'
  s.license     = 'emojidex asset license'
  s.summary     = 'Vectorized [SVG] emoji assets for emojidex.'
  s.description = 'Vectorized [SVG] assets for emojidex. These assets can be used as a gem and combined with emojidex-toolkit and emojidex-converter.'
  s.authors     = ['Jun Tohyama', 'Rei Kagetsuki']
  s.email       = 'info@emojidex.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ['lib']
  s.homepage    = 'http://dev.emojidex.com'

  s.add_dependency 'rsvg2'
  s.add_dependency 'rmagick'
  s.add_dependency 'cairo'
  s.add_dependency 'json'
end
