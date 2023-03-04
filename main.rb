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
    break if cache[state] == true

    cache[state] = true
    @arr << state[0]
  end
  File.write('M-seq.txt', @arr)
  @arr
end

def state_generate(len)
  rand(2**(len - 1)...2**len)
end

def read_key
  File.read(KEY_FILE).strip
end

def pirson_criterion(_n_teor, _n_prac, k)
  2**k.times do
  end
end

def n_teor(m_sequence, block_length)
  n_teor = m_sequence.length / (2**block_length * block_length.to_f)
end

def psi(n_teor, m_series_counts)
  m_series_counts.values.sum do |count|
    puts count
    ((count - n_teor)**2) / n_teor.to_f
  end
end

def serial_test(m_sequence, block_length)
  m_series = m_sequence.each_slice(block_length).to_a
  m_series = m_series[0, (m_series.size - 1)] unless m_series.last.length == block_length
  m_series_counts = Hash.new(0)
  m_series.each do |seq|
    m_series_counts[seq] += 1
  end
  m_series_frequencies = m_series_counts.each.each_with_object({}) do |el, memo|
    memo[el[0]] = el[1] / (m_sequence.length.to_f / block_length).to_f
  end
  puts m_series_counts
  puts m_series_frequencies
  n_teor = n_teor(m_sequence, block_length)
  puts n_teor
  puts psi(n_teor, m_series_counts)
end

def start(len, cs)
  if ARGV.include? 'read'
    key = read_key
    len = key.length
  end
  state = key&.to_i(2) || state_generate(len)
  File.write(KEY_FILE, state.to_s(2))
  m_seq = m_sequence_generate(len, state, cs)
  serial_test(m_seq, 3)
end

len = 25

cs = [23, 9]

start(len, cs)
