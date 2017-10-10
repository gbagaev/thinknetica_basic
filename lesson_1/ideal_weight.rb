puts 'What is your name?'
name = gets.chomp
puts 'What is your height?'
height = gets.to_f

weight = height - 110

if weight >= 0
  puts "#{name}, hello! Your ideal weight is #{weight}."
else
  puts 'Your weight is already optimal'
end
