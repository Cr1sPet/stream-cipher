# frozen_string_literal: true

require 'debug'

KEY_FILE = 'key.txt'
M_SEQ_FILE = 'M-seq.txt'

def generate_m_sequence(length, state, feedback_bits)
  count = 2**length - 1
  arr = [state[0]]
  cache = { state => true }

  count.times do
    digits = feedback_bits.map { |bit| state[bit - 1] }
    result = digits.inject(:^)
    state = (state >> 1) | (result << length - 1)
    break if cache[state]

    cache[state] = true
    arr << state[0]
  end

  File.write(M_SEQ_FILE, arr)
  arr
end

def generate_state(length)
  rand(2**(length - 1)...2**length)
end

def read_key
  File.read(KEY_FILE).strip
end

def pirson_criterion(psi, k)
  case k
  when 2
    psi >= 0.584 && psi <= 6.251
  when 3
    psi >= 2.833 && psi <= 12.017
  when 4
    psi >= 8.547 && psi <= 22.307
  end
end

def theoretical_n(m_sequence, block_length)
  m_sequence.length / (2**block_length * block_length.to_f)
end

def calculate_psi(theoretical_n, m_series_counts)
  m_series_counts.values.sum do |count|
    ((count - theoretical_n)**2) / theoretical_n.to_f
  end
end

def serial_test(m_sequence, block_length)
  m_series = m_sequence.each_slice(block_length).to_a
  m_series = m_series[0, (m_series.size - 1)] unless m_series.last.length == block_length
  m_series_counts = Hash.new(0)

  m_series.each do |seq|
    m_series_counts[seq] += 1
  end

  m_series_frequencies = m_series_counts.transform_values do |count|
    count / (m_sequence.length.to_f / block_length).to_f
  end

  theoretical_n = theoretical_n(m_sequence, block_length)
  psi = calculate_psi(theoretical_n, m_series_counts)

  puts m_series_counts
  puts m_series_frequencies
  puts theoretical_n
  puts psi
  puts "Pirson criterion result: #{pirson_criterion(psi, block_length)}"
end

def start(length, feedback_bits, block_length)
  if ARGV.include? '--mRead'
    key = read_key
    length = key.length
  end

  state = key&.to_i(2) || generate_state(length)
  File.write(KEY_FILE, state.to_s(2))
  m_sequence = generate_m_sequence(length, state, feedback_bits)
  serial_test(m_sequence, block_length)
end

length = 25
feedback_bits = [23, 9]
block_length = 2

start(length, feedback_bits, block_length)
