class XorEncoder
  def self.call(...) = new(...).call

  def initialize(m_seq:, input:)
    @m_seq = m_seq
    @input = input
  end

  def call
    key = Utils.bit_array_to_byte_array(m_seq).take(input.size)
    encode(input, key)
  end


  private

  attr_reader :m_seq, :input

  def encode(input, key)
    result = []
    input.each_with_index do |byte, i|
      result << (byte ^ key[i])
    end
    result
  end
end
