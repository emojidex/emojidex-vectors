require_relative 'combinations/base_generator'

combo_sets_path = '../src/combinations/'

combos = Dir.entries(combo_sets_path)
combos -= ['.']
combos -= ['..']


combos.each do |combo|
  puts "⚙ Processing #{combo}"
  gen = ComboEmojiBaseGenerator.new("#{combo_sets_path}#{combo}")
  puts "\t[#{gen.status}]"
end
