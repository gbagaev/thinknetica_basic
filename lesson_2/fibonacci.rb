a = []
n = 0
while n <= 100
  if a.size < 2
    a << n
    n += 1
  else
    a << a[-1] + a[-2]
    n = a[-1] + a[-2]
  end
end
puts a.inspect
