def humanize(n, power, units):
  unit = 0
  mod = 0

  mod_power = power / 10
  if power % 10 != 0:
    mod_power += 1

  while n >= power and unit < len(units) - 1:
    mod = n % power
    n = int(n / power)
    unit += 1

  if mod != 0:
    return "{0}.{1}{2}".format(n, int(mod / mod_power), units[unit])
  else:
    return "{0}{1}".format(n, units[unit])

def iec(n):
  return humanize(n, 1024, [ '', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB' ])

def si(n):
  return humanize(n, 1000, [ '', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' ])

def bits(n):
  b = []

  while n != 0:
    b.append(n & 1)
    n = int (n / 2)

  for i in range(len(b)):
    pos = len(b) - i - 1
    print(pos, end=" ")

  print("")

  for i in range(len(b)):
    pos = len(b) - i - 1
    title_len = len(str(pos))
    print(str(b[i]).rjust(title_len), end=" ")

  return ""

def b(n):
  return bin(n)

def o(n):
  return oct(n)

def h(n):
  return hex(n)
