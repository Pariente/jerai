require 'fileutils'
require 'json'
require 'colorize'

puts "\n--- Choose a user. Type '0' for Thomas and '1' for Lucas. ---\n".light_red
user = gets.chomp

# FETCHING MEANINGLESS WORDS LIST
meaningless = File.open('meaningless_words.txt').read

if user == '0'
  # FETCHING MAROT HASH FROM JSON FILE
  user_json_file = File.read('pariente/pariente.json')
  user_hash = JSON.parse(user_json_file)
else
  # FETCHING MAROT HASH FROM JSON FILE
  user_json_file = File.read('marot/marot.json')
  user_hash = JSON.parse(user_json_file)
end

p user_hash.to_h

# COUNTING TOTAL WEIGHT OF MAROT HASH
user_count = 0
user_hash.map {|h| user_count += h[1]}
user_hash = user_hash.to_h

puts "\n--- Choose a doc to calculate cosine similarity (ex: 'sample.txt') ---\n".light_red
file = gets.chomp

# INITIALIZING DOC HASH
doc = File.open(file).read
doc_words = doc.encode('UTF-8', :invalid => :replace).split(/\W+/)
doc_hash = Hash.new(0)

# BUILDING DOC HASH
doc_words.each do |word|
  meaning = true
  meaningless.each_line do |line|
    break if meaning == false
    meaning = false if word.to_s.downcase == line.delete("\n")
  end
  doc_hash[word.to_s.downcase] += 1 unless meaning == false
end

# # COUNTING TOTAL WEIGHT OF DOC HASH
# doc_count = 0
# doc_hash.map {|h| doc_count += h[1]}

# # MULTIPLYING EACH VALUE OF DOC HASH SO THAT TOTAL WEIGHT IS THE SAME AS MAROT HASH
# if user_count >= doc_count
#   multiplier = user_count / doc_count
# else
#   multiplier = doc_count / user_count
# end
# doc_hash.map {|h| h[1] = h[1] * multiplier}
# doc_hash = doc_hash.to_h


def cosinesim(hash1, hash2)
  keys = (hash1.keys + hash2.keys).uniq
  num = 0
  denum1 = 0
  denum2 = 0
  keys.each do |k|
    if hash1[k] == nil
      hash1[k] = 0
    end
    if hash2[k] == nil
      hash2[k] = 0
    end
    num += (hash1[k] * hash2[k])
    denum1 += hash1[k] * hash1[k]
    denum2 += hash2[k] * hash2[k]
  end
  denum = Math.sqrt(denum1 * denum2)

  return num/denum
end

puts "\n--- The Cosine Similarity is ---\n".light_red
p cosinesim(user_hash, doc_hash)