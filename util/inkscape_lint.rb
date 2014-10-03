#!/usr/bin/env ruby

#########################################
# inkscape_lint
#
# uses inkscape to re-save SVG images
# cleaning out dirty/non-standard
# adobe etc. namespaces
#########################################

require 'rubygems'

gem 'emojidex'

require 'fileutils'
require 'emojidex'

emoji_root = File.expand_path('../../emoji/', __FILE__)
utf_path = File.expand_path('utf', emoji_root)
extended_path = File.expand_path('extended', emoji_root)

utf = Emojidex::Collection.new
utf.load_local_collection utf_path

extended = Emojidex::Collection.new
extended.load_local_collection extended_path

utf.each do |moji|
  `inkscape --vacuum-defs #{utf_path}/#{moji.code}.svg`
end

extended.each do |moji|
  `inkscape --vacuum-defs #{extended_path}/#{moji.code}.svg`
end
