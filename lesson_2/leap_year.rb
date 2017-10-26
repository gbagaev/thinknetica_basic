puts 'Enter day of the month'
day = gets.to_i
puts 'Enter month'
month = gets.to_i
puts 'Enter year'
year = gets.to_i

months = {
    1 => 31,
    2 => 28,
    3 => 31,
    4 => 30,
    5 => 31,
    6 => 30,
    7 => 31,
    8 => 31,
    9 => 30,
    10 => 31,
    11 => 30,
    12 => 31
}

leap = year % 4 == 0 && year % 100 != 0 || year % 400 == 0

months[2] = 29 if leap

ordinal_number =
    if month == 1
      day
    else
      (1..(month-1)).inject(0) { |summ, num| summ += months[num] } + day
    end

puts "The ordinal number of the entered date is #{ordinal_number}"
