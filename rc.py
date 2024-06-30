import socket
import ipaddress
import sys

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
    print(str(b[pos]).rjust(title_len), end=" ")

  return ""

def b(n):
  return bin(n)

def o(n):
  return oct(n)

def h(n):
  return hex(n)

def htons(x):
  return socket.htons(x)

def ntohs(x):
  return socket.ntohs(x)

def htonl(x):
  return socket.htonl(x)

def ntohl(x):
  return socket.ntohl(x)

def ip2hex(val):
  prefix = None
  try:
    str_ip, str_prefix = val.split("/")
    prefix = int(str_prefix)
  except:
    str_ip = val

  ip = None
  if '\\' in str_ip:
    str_ip = bytes(str_ip, "utf-8").decode("unicode_escape")
    str_ip = bytes(str_ip, "utf-8")
    ip = ipaddress.ip_address(str_ip)
  elif '.' in str_ip or ':' in str_ip:
    ip = ipaddress.ip_address(str_ip)
  else:
    b = bytearray.fromhex(str_ip)

    try:
      # TODO: move this under a flag
      # /proc/net/tcp6
      b[12], b[13], b[14], b[15] = b[15], b[14], b[13], b[12]
      b[8], b[9], b[10], b[11] = b[11], b[10], b[9], b[8]
      b[4], b[5], b[6], b[7] = b[7], b[6], b[5], b[4]
      b[0], b[1], b[2], b[3] = b[3], b[2], b[1], b[0]
    except:
      pass

    ip = ipaddress.ip_address(bytes(b))

  print(ip.exploded, ip.packed.hex())

  if prefix:
    net = ipaddress.ip_network(ip.exploded + "/" + str(prefix), False)
    print(net.exploded)
    print("/{}: {} {}".format(prefix, net.netmask, net.netmask.packed.hex()))

  return ""
