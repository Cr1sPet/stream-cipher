# frozen_string_literal: true

require 'debug'
require 'optparse'
require_relative 'options_parser'
require_relative 'key_generator'
require_relative 'm_sequence_generator'
require_relative 'serial_tester'
require_relative 'correlation_tester'

KEY_FILE = 'key.txt'

def read_key
  File.read(KEY_FILE).strip
end

def start(options)
  case options[:mode]
  when 'ENCRYPT'

  when 'DECRYPT'

  end
  state = if options[:key_filename]
            read_key.to_i(2)
          else
            KeyGenerator.call(options[:length])
          end
  File.write(KEY_FILE, state.to_s(2))
  length = options[:key_filename] ? state.to_s(2).length : options[:length]
  m_sequence = MSequenceGenerator.call(length: length,
                                       state: state,
                                       feedback_filename: options[:feedback_filename])
  SerialTester.call(m_sequence: m_sequence, block_length: options[:block_length])
  CorrelationTester.call(m_sequence: m_sequence)
end

begin
  options = OptionsParser.parse
  start(options)
  # rescue StandardError => e
  #   puts e.message
  #   puts e.class
end
