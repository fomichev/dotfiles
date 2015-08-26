class Integer
  # Convert number to string with given base
  def self.to_base(number, base, plain)
    prefix = ''
    suffix = ''

    prefix = '0x' if base == 16
    prefix = '0' if base == 8

    if plain
      prefix + number.to_s(base)
    else
      z = number.to_s(base).reverse.scan(/.{1,4}/)
      z = z.map { |e| e.reverse }

      prefix + z.reverse.join('_')
    end
  end

  # Convert to given units
  def self.humanify(n, power, units)
    unit = 0
    mod = 0

    mod_power = power / 10
    mod_power += 1 if power % 10 != 0

    while n >= power and unit < units.size - 1
      mod = n % power
      n = n / power
      unit += 1
    end

    if mod != 0
      "#{n}.#{mod / mod_power}#{units[unit]}"
    else
      "#{n}#{units[unit]}"
    end
  end

  # Return string representation of the number converted to IEC units
  def iec
    Integer.humanify(self, 1024, [ '', 'KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB' ])
  end

  # Return string representation of the number converted to SI units
  def si
    Integer.humanify(self, 1000, [ '', 'kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB' ])
  end

  # Print binary representation of a number and associated bit position
  def bits
    b = []

    n = self

    while n != 0
      b << (n & 1)
      n /= 2
    end

    b.each_with_index do |x, i|
      pos = b.length - i - 1

      print "#{pos} "
    end
    puts

    b.reverse.each_with_index do |x, i|
      pos = b.length - i - 1

      l = pos.to_s.length

      print "#{x.to_s.rjust(l)} "
    end
    puts

    nil
  end

  def k
    self * 1024
  end

  def m
    self.k * 1024
  end

  def g
    self.m * 1024
  end

  # Convert number to string containing binary representation
  def b(split=false)
    Integer.to_base(self, 2, !split)
  end

  # Convert number to string containing octal representation
  def o(split=false)
    Integer.to_base(self, 8, !split)
  end

  # Convert number to string containing decimal representation
  def d(split=false)
    Integer.to_base(self, 10, !split)
  end

  # Convert number to string containing hexadecimal representation
  def h(split=false)
    Integer.to_base(self, 16, !split)
  end

  # Print combined information about number
  def i(split=true)
    converted = {
      bin: self.b(split),
      oct: self.o(split),
      dec: self.d(split),
      hex: self.h(split)
    }

    len = converted.map { |k, v| v.length }.max

    puts self.bits

    converted.each do |k, v|
      case k
      when :dec
        puts "#{converted[:dec].rjust(len)} #{self.iec} #{self.si}"
      else
        puts converted[k].rjust(len)
      end
    end

    nil
  end
end
