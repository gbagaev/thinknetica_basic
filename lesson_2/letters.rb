letters = %w( a e i o u )
result = {}

('A'..'Z').each_with_index do |letter, index|
  if letters.include?(letter)
    result[letter] = index + 1
  end
end
puts result


letters = %w( a e i o u )
result = {}

('a'..'z').each_with_index do |letter, index|
  if letters.include?(letter)
    result[letter] = index + 1
  end
end
puts result
