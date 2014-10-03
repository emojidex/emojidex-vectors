#!/usr/bin/env ruby

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

emoji_root = File.expand_path('../../emoji/', __FILE__)
utf_path = File.expand_path('utf', emoji_root)
extended_path = File.expand_path('extended', emoji_root)

# Convert
converter = Emojidex::Converter.new()
puts "preprocessing/compiling SVG frames to SVG"
# UTF
converter.preprocess(utf_path)
# Extended
converter.preprocess(extended_path)
