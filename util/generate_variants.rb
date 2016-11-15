require_relative 'combinations/variant_generator'

combo_sets_path = '../emoji/variants/'

combos = Dir.entries(combo_sets_path)
combos -= ['.']
combos -= ['..']
combos -= ['components']


combos.each do |combo|
  puts "⚙ Processing #{combo}"
  gen = VariantGenerator.new("#{combo_sets_path}#{combo}")
  puts "\t[#{gen.status}]"
end
