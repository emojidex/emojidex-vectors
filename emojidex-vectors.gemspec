Gem::Specification.new do |s|
  s.name        = 'emojidex-vectors'
  s.version     = '0.0.1'
  s.license     = 'emojidex General License'
  s.summary     = 'Vectorized [SVG] emoji assets for emojidex.'
  s.description = 'Vectorized [SVG] assets for emojidex. These assets can be used as a gem and combined with emojidex-toolkit and emojidex-converter.'
  s.authors     = ['Jun Tohyama', 'Rei Kagetsuki', 'Rika Yoshida']
  s.email       = 'info@emojidex.com'
  s.files       = `git ls-files`.split($/)
  s.require_paths = ['lib']
  s.homepage    = 'http://developer.emojidex.com'
end
