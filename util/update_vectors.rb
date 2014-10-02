#########################################
# update_rasters
#
# Re-compile frame animated SVGs from 
# original SVG frame sources
#########################################

require 'rubygems'

gem 'emojidex'
gem 'emojidex-converter'

require 'emojidex'
require 'emojidex_converter'

# UTF
converter = Emojidex::Converter.new()

puts "preprocessing/compiling SVG frames to SVG"
converter.preprocess('../emoji/utf')
converter.preprocess('../emoji/extended')
