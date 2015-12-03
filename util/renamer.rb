#!/usr/bin/env ruby


#########################################
# renamer
#
# changes full_name file names to to code 
#########################################

require 'rubygems'

gem 'emojidex'

require 'fileutils'
require 'emojidex'

emoji_root = File.expand_path('../../emoji/', __FILE__)
utf_path = File.expand_path('utf', emoji_root)
extended_path = File.expand_path('extended', emoji_root)

utf = Emojidex::Data::Collection.new
utf.load_local_collection utf_path

extended = Emojidex::Data::Collection.new
extended.load_local_collection extended_path

variants = ['(br)', '(bk)']
# check if variant extended emoji contain UTF full_name
utf.each do |moji|
  h = moji.to_hash
  if h['full_name']
    variants.each do |variant|
      check = extended.emoji[(h['full_name'] + variant).to_sym]
      next if check.nil?
      puts "Moving: #{check.to_hash['code']}.svg to " + 
            "#{(h['code'] + variant).to_s}.svg"
      if File.exist? "#{extended_path}/#{check.to_hash['code']}.svg"
        FileUtils.mv("#{extended_path}/#{check.to_hash['code']}.svg",
                     "#{extended_path}/#{(h['code'] + variant).to_s}.svg")
      end
      check.code = (h['code'] + variant).to_s
      extended.write_index("#{extended_path}")
      json = JSON.parse(IO.read("#{extended_path}/emoji.json"))
      File.open("#{extended_path}/emoji.json", 'w') { |f| f.write JSON::pretty_generate(json) }
    end
  end
end
