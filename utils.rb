# frozen_string_literal: true

class Utils
  def self.read_bin_file(plain)
    bytes = []
    File.open(plain, 'rb') do |file|
      bytes = file.read.bytes
    end
    bytes
  end

  def self.write_bin_file(data, path)
    File.open(path, 'wb') do |file|
      file.write(data.pack('C*'))
    end
  end

  def self.byte_array_to_bit_array(bytes)
    bytes.map { |byte| byte.to_s(2).rjust(8, '0') }.join('').split('').map(&:to_i)
  end

  def self.bit_array_to_byte_array(bits)
    key = []
    bits.each_slice(8) do |slice|
      n = slice.inject(0) { |sum, bit| (sum << 1) + bit }
      key << n
    end
    key
  end
end
