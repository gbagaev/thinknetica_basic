puts 'Enter the coefficient a'
a = gets.to_f
puts 'Enter the coefficient b'
b= gets.to_f
puts 'Enter the coefficient c'
c = gets.to_f

d = b**2 - 4 * a * c
divider = 2 * a

if d > 0
  d_root = Math.sqrt(d)
  puts "D = #{d}"
  puts "x1 = #{(-b + d_root) / divider}"
  puts "x2 = #{(-b - d_root) / divider}"
elsif d == 0
  puts "D = #{d}"
  puts "x1 = x2 = #{-b / divider}"
else d < 0
  puts "D = #{d}"
  puts 'No roots!'
end
