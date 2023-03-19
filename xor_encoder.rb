class XorEncoder
  def self.call(...) = new(...).call

  def initialize(m_seq:, input:, output:)
    @m_seq = m_seq
    @input = input
    @output = output
  end

  def call
    key = []
    m_seq.each_slice(8) do |slice|
      n = slice.inject(0) { |sum, bit| (sum << 1) + bit }
      key << n
    end
    key = key.take(input.size)

    encode(input, key, output)

  end


  private

  attr_reader :m_seq, :input, :output

  def encode(input, key, output)
    result = []
    input.each_with_index do |byte, i|
      result << (byte ^ key[i])
    end

    File.open(output, "wb") do |file|
      file.write(result.pack("C*"))
    end

    result
  end
end
