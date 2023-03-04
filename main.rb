# frozen_string_literal: true

require_relative 'crypto'
require 'debug'
include StreamCipher

KEY_FILE = 'key.txt'

def m_sequence_generate(len, state, cs)
  count = 2**len - 1
  @arr = []
  @arr << state[0]
  cache = Hash.new(false)
  cache[state] = true
  count.times do
    digits = cs.map { |c| state[c - 1] }
    result = digits.inject(:^)
    state = (state >> 1) | (result << len - 1)
    if cache[state] == true
      break
    end
    cache[state] = true
    @arr << state[0]
  end
  @arr
  File.write('M-seq.txt', @arr)
end

def state_generate(len)
  rand(2**(len - 1)...2**len)
end

def read_key
  File.read(KEY_FILE).strip
end

def start(len, cs)
  if ARGV.include? 'read'
    key = read_key
    len = key.length
  end
  state = key&.to_i(2) || state_generate(len)
  File.write(KEY_FILE, state.to_s(2))
  m_sequence_generate(len, state, cs)
end

len = 25

cs = [23, 9]
start(len, cs)
