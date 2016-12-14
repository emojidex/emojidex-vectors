require_relative 'generators/component_generator'

component_sets_path = '../src/components/'

components = Dir.entries(component_sets_path)
components -= ['.']
components -= ['..']


components.each do |component|
  puts "⚙ Processing #{component}"
  gen = ComponentGenerator.new("#{component_sets_path}#{component}")
  puts "\t[#{gen.status}]"
end
