puts 'Enter the width of the side 1 of the triangle'
side1 = gets.to_f
puts 'Enter the width of the side 2 of the triangle'
side2 = gets.to_f
puts 'Enter the width of the side 3 of the triangle'
side3 = gets.to_f

if side1 > side2 && side1 > side3
  gipotenuz = side1
  katet1 = side2
  katet2 = side3

elsif side2 > side1 && side2 > side3
  gipotenuz = side2
  katet1 = side1
  katet2 = side3

elsif side3 > side1 && side3 > side2
  gipotenuz = side3
  katet1 = side1
  katet2 = side2

else
  gipotenuz = side1
  katet1 = side1
  katet2 = side1
end

if side1 == side2 && side1 == side3
  puts 'Your triangle is equilateral'
else
  puts 'Your triangle is rectangular' if gipotenuz ** 2 == katet1 ** 2 + katet2 ** 2
  puts 'Your triangle is isosceles' if katet1 == katet2
  puts 'Your triangle is not isosceles' unless katet1 == katet2
end
