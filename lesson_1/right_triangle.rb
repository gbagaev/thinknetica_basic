puts 'Enter the width of the side 1 of the triangle'
side1 = gets.to_i
puts 'Enter the width of the side 2 of the triangle'
side2 = gets.to_i
puts 'Enter the width of the side 3 of the triangle'
side3 = gets.to_i

if side1**2 == side2**2 + side3**2 or side2**2 == side1**2 + side3**2 or side3**2 == side1**2 + side2**2
  puts 'Your triangle is rectangular'
elsif side1 == side2 && side1 == side3
  puts 'Your triangle is equilateral'
elsif side1 == side2 || side1 == side3 || side2 == side3
  puts 'Your triangle is isosceles'
else
  puts 'Your triangle is not rectangular'
end
