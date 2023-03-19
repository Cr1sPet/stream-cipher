class CorrelationTester
  def self.call(...) = new(...).call

  def initialize(m_sequence:)
    @k = [1, 2, 8, 9]
    @r = {}
    @m_seq = m_sequence
    @n = m_seq.length
  end

  def call
    correlation_test
    puts r
    puts r_border
  end

  private

  attr_reader :m_seq, :k, :r, :n

  def correlation_test
    k.each do |i|
      debugger
      m_i = m_seq[0..-i-1].sum.to_f / (m_seq.length - i)
      m_i_k = m_seq[i..-1].sum.to_f / (m_seq.length - i)

      d_i = m_seq[0..-i-1].inject(0) { |sum, x| sum + (x.to_f - m_i)**2 } / (m_seq.length - i - 1)
      d_i_k = m_seq[i..-1].inject(0) { |sum, x| sum + (x.to_f - m_i_k)**2 } / (m_seq.length - i - 1)

      r[i] = m_seq.each_cons(i+1).inject(0) { |sum, pair| sum + (pair[0].to_f - m_i) * (pair[i].to_f - m_i_k) } / (m_seq.length - i)
      r[i] /= Math.sqrt(d_i * d_i_k)
      r[i] = r[i].abs
    end
  end

  def r_border
    1.0 / (n - 1) + (2.0 / (n - 2)) * Math.sqrt(n * (n - 3)/ n + 1)
  end
end
