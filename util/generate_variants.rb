require_relative 'generators/variant_generator'

variant_sets_path = '../src/variants/'

variants = Dir.entries(variant_sets_path)
variants -= ['.']
variants -= ['..']

if ARGV.length > 0
  puts "Trying #{ARGV}"
  ARGV.each do |arg|
    if variants.include?(arg)
      puts "⚙ Processing #{arg}"
      gen = VariantGenerator.new("#{variant_sets_path}#{arg}")
      puts "\t[#{gen.status}]"
    end
  end
else
  variants.each do |variant|
    puts "⚙ Processing #{variant}"
    gen = VariantGenerator.new("#{variant_sets_path}#{variant}")
    puts "\t[#{gen.status}]"
  end
end
