Gem::Specification.new do |s|
  s.name        = 'emojidex-vectors'
  s.version     = '1.0.9'
  s.license     = 'emojidex Open License'
  s.summary     = 'Vectorized [SVG] emoji assets for emojidex.'
  s.description = 'Vectorized [SVG] assets for emojidex. These assets can be used as a gem and combined with emojidex-toolkit and emojidex-converter.'
  s.authors     = ['Jun Tohyama', 'Yoshihiro Tsuchiyama', 'Rei Kagetsuki', 'Rika Yoshida']
  s.email       = 'info@emojidex.com'
  s.files       = Dir.glob('emoji/**/*') +
                  Dir.glob('lib/**/*.rb') +
                  ['emojidex-vectors.gemspec']
  s.require_paths = ['lib']
  s.homepage    = 'http://developer.emojidex.com'
end
