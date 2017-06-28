# encoding: utf-8

require 'fileutils'
require 'json'

meaningless = File.open('meaningless_words.txt').read

occurs_marot = Hash.new(0)

Dir.foreach('marot') do |item|
  next if item == '.' or item == '..'
  read = File.open('marot/'+item).read
  words = read.encode('UTF-8', :invalid => :replace).split(/\W+/)

  words.each do |word|
    meaning = true
    meaningless.each_line do |line|
      break if meaning == false
      meaning = false if word.to_s.downcase == line.delete("\n")
    end
    occurs_marot[word.to_s.downcase] += 1 unless meaning == false
  end
end

occurs_marot = occurs_marot.sort_by {|x,y| y}.reverse!

open('marot/marot.json', 'w') do |f|
  f.write(occurs_marot.to_json)
end