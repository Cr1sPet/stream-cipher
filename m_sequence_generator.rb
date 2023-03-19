class MSequenceGenerator
  def self.call(...) = new(...).call

  def initialize(length:, state:, feedback_filename:)
    @length = length
    @state = state
    @feedback_bits = File.read(feedback_filename).strip.split(' ').map(&:to_i)
  end

  def call
    generate_m_sequence(length, state, feedback_bits)
  end

  private
  attr_reader :length, :state, :feedback_bits

  M_SEQ_FILE = 'M-seq.txt'

  def generate_m_sequence(length, state, feedback_bits)
    count = 2**length - 1
    arr = [state[0]]
    cache = { state => true }

    count.times do
      result = feedback_bits.map { |bit| state[bit - 1] }.inject(:^)
      state = (state >> 1) | (result << length - 1)
      break if cache[state]

      cache[state] = true
      arr << state[0]
    end

    File.write(M_SEQ_FILE, arr)
    arr
  end
end
