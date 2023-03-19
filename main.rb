# frozen_string_literal: true

require 'debug'
require 'optparse'
require_relative 'options_parser'
require_relative 'key_generator'
require_relative 'm_sequence_generator'
require_relative 'serial_tester'
require_relative 'correlation_tester'
require_relative 'xor_encoder'
require_relative 'utils'

KEY_FILE = 'key.txt'
PLAIN = 'wow.jpeg'

def read_key(key_file:)
  key_file ||= KEY_FILE
  File.read(key_file).strip
end

def generate_key_or_use_from_file(options)
  state = if options[:key_filename]
            read_key(key_file: options[:key_filename]).to_i(2)
          else
            KeyGenerator.call(length: options[:length])
          end
  File.write(KEY_FILE, state.to_s(2))
  length = options[:key_filename] ? state.to_s(2).length : options[:length]
  [state, length]
end

def start(options)
  state, length = generate_key_or_use_from_file(options)
  m_sequence = MSequenceGenerator.call(length: length, state: state, feedback_filename: options[:feedback_filename])

  SerialTester.call(m_sequence: m_sequence, block_length: options[:block_length])
  CorrelationTester.call(m_sequence: m_sequence)

  input = Utils.read_bin_file(PLAIN)

  encrypted = XorEncoder.call(m_seq: m_sequence, input: input)
  decrypted = XorEncoder.call(m_seq: m_sequence, input: encrypted)

  Utils.write_bin_file(encrypted, "encrypted-#{PLAIN}")
  Utils.write_bin_file(decrypted, "decrypted-#{PLAIN}")

  bit_input = Utils.byte_array_to_bit_array(input)
  bit_encrypted = Utils.byte_array_to_bit_array(encrypted)

  SerialTester.call(m_sequence: bit_input, block_length: options[:block_length])
  CorrelationTester.call(m_sequence: bit_input)

  SerialTester.call(m_sequence: bit_encrypted, block_length: options[:block_length])
  CorrelationTester.call(m_sequence: bit_encrypted)
end

begin
  options = OptionsParser.parse
  start(options)
  # rescue StandardError => e
  #   puts e.message
  #   puts e.class
end
