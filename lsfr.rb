# frozen_string_literal: true

def lfsr(poly, seed)
  bits = seed.bit_length
  taps = poly.scan(/(?<=\^)\d+/).map(&:to_i)

  Enumerator.new do |enum|
    loop do
      enum.yield(seed & 1)
      feedback = 0
      taps.each { |tap| feedback ^= seed[tap] }
      seed >>= 1
      seed |= feedback << (bits - 1)
    end
  end
end

poly = 'x^4 + x^1 + 1'
seed = 0b1000
length = 16

lfsr(poly, seed).take(length).each { |bit| print "#{bit} " }
