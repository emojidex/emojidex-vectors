require 'phantom_svg'
require 'emojidex/collection'


def clean_vector(emoji, source_dir)
  start_time = Time.now
  emoji.each do |moji|
    phantom_svg = Phantom::SVG::Base.new("#{source_dir}/#{moji.code}.svg")
    # Set size again just in case
    phantom_svg.width = phantom_svg.height = 64
    # Re-render SVG
    puts "Re-rendering: #{source_dir}/#{moji.code}.svg"
    phantom_svg.save_apng("#{source_dir}/#{moji.code}.svg")
    phantom_svg.reset
    phantom_svg = nil
    GC.start
  end

  run_time = Time.now - start_time
  puts "Total Converstion Time: #{run_time}"
end

utf = Emojidex::Collection.new(nil, File.expand_path('../../emoji/utf'))
puts "Opening UTF collection with #{utf.emoji.count} emoji"

