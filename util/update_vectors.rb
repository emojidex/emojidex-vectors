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

# Check
utf = Emojidex::Collection.new
utf.load_local_collection utf_path
utf_cc = Emojidex::CollectionChecker.new(utf, formats: [:svg])
if utf_cc.asset_only.empty? && utf_cc.index_only.empty?
  puts "UTF Collection OK!"
else
  puts "UTF Collection missing assets/indexes. Halting."
  exit 1
end


# Check
extended = Emojidex::Collection.new
extended.load_local_collection extended_path
extended_cc = Emojidex::CollectionChecker.new(extended, formats: [:svg])
if extended_cc.asset_only.empty? && extended_cc.index_only.empty?
  puts "Extended Collection OK!"
else
  puts "Extended Collection missing assets/indexes. Halting."
  puts "Asset Only:\n"
  extended_cc.asset_only.each { |a| puts "[#{a}]\n" }
  puts "Index Only: \n"
  extended_cc.index_only.each { |i| puts "[#{i}]\n" }
  exit 2
end

# Convert
converter = Emojidex::Converter.new()
puts "preprocessing/compiling SVG frames to SVG"
# UTF
converter.preprocess(utf_path)
# Extended
converter.preprocess(extended_path)
