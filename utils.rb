# frozen_string_literal: true

class Utils
  def self.read_bin_file(plain)
    bytes = []
    File.open(plain, 'rb') do |file|
      bytes = file.read.bytes
    end
    bytes
  end

  def self.byte_array_to_bit_array(bytes)
    bytes.map { |byte| byte.to_s(2).rjust(8, '0') }.join('').split('').map(&:to_i)
  end
end
