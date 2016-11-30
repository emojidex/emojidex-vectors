require_relative 'combinations/variant_generator'

variant_sets_path = '../emoji/variants/'

variants = Dir.entries(variant_sets_path)
variants -= ['.']
variants -= ['..']
variants -= ['components']

variants.each do |variant|
  puts "⚙ Processing #{variant}"
  gen = VariantGenerator.new("#{variant_sets_path}#{variant}")
  puts "\t[#{gen.status}]"
end
