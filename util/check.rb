#!/usr/bin/env ruby

#########################################
# check
#
# check files and indexes 
#########################################

require 'rubygems'

gem 'emojidex'
gem 'emojidex-converter'

require 'emojidex'
require 'emojidex_converter'
require 'json'

emoji_root = File.expand_path('../../emoji/', __FILE__)
utf_path = File.expand_path('utf', emoji_root)
extended_path = File.expand_path('extended', emoji_root)

category_names = []
Emojidex::Data::Categories.new.each { |category| category_names << category.code.to_s }


# Check
utf = Emojidex::Data::Collection.new
utf.load_local_collection utf_path
utf_cc = Emojidex::Data::CollectionChecker.new(utf, formats: [:svg])
if utf_cc.asset_only.empty? && utf_cc.index_only.empty?
  puts "UTF Collection OK!"
else
  puts "UTF Collection missing assets/indexes. Halting."
  puts "Asset Only:\n"
  utf_cc.asset_only.each { |a| puts "[#{a}]\n" }
  puts "Index Only: \n"
  utf_cc.index_only.each { |i| puts "[#{i}]\n" }
  exit 1
end


# Check
extended = Emojidex::Data::Collection.new
extended.load_local_collection extended_path
extended_cc = Emojidex::Data::CollectionChecker.new(extended, formats: [:svg])
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


# Category name check
(all_emoji = utf) << extended
all_emoji.each do |emoji|
  unless category_names.include?(emoji.category.to_s)
    puts "Contains the wrong category name."
    puts emoji["code"]
  end
end


# Duplicate check
class Array
  def duplicate_check(*arrays)
    self.sort!
    self.each_with_index do |v, i|
      puts "duplicate code #{v}" if v == self[i+1]
    end
  end
end

emoji_names = Array.new
emoji_ja_names = Array.new

list = JSON.parse(IO.read("#{utf_path}/emoji.json"), symbolize_names: true)
list.concat(JSON.parse(IO.read("#{extended_path}/emoji.json"), symbolize_names: true))
list.each do |emoji|
  emoji_names << emoji[:code]
  emoji_ja_names << emoji[:code_ja]
end

emoji_names.duplicate_check
emoji_ja_names.duplicate_check
