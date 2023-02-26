# frozen_string_literal: true

require_relative 'crypto'
require 'debug'
include StreamCipher

@arr = []

def start(l, s)
  state = count = 2**l - 1

  puts "%0#{l}b" % state
  @arr << state[0]
  count.times do
    first_digit = state[l - 1]
    last_digit = state[s - 1]
    result = first_digit ^ last_digit
    state = (state >> 1) | (result << l - 1)
    @arr << state[0]
    puts "%0#{l}b" % state
  end
  print @arr
end

l = 5
s = 2
start(l, s)
