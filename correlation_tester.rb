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
    @k.each do |k|
      m_i = 0.0
      (0..m_seq.length - k - 1).each do |j|
        m_i += m_seq[j].to_f
      end
      m_i *= 1 / (m_seq.length - k).to_f

      m_i_k = 0.0
      (k..m_seq.length - 1).each do |j|
        m_i_k += m_seq[j].to_f
      end
      m_i_k *= 1 / (m_seq.length - k).to_f

      d_i = 0.0
      (0..m_seq.length - k - 1).each do |j|
        d_i += (m_seq[j].to_f - m_i)**2
      end
      d_i *= 1 / (m_seq.length - k - 1).to_f

      d_i_k = 0.0
      (k..m_seq.length - 1).each do |j|
        d_i_k += (m_seq[j].to_f - m_i_k)**2
      end
      d_i_k *= 1 / (m_seq.length - k - 1).to_f

      @r[k] = 0.0
      (0..m_seq.length - k - 1).each do |i|
        @r[k] += (m_seq[i].to_f - m_i) * (m_seq[i + k].to_f - m_i_k)
      end
      @r[k] /= (m_seq.length - k).to_f
      @r[k] /= Math.sqrt(d_i * d_i_k)
      @r[k] = @r[k].abs
    end
  end

  def r_border
    1.0 / (n - 1) + (2.0 / (n - 2)) * Math.sqrt(n * (n - 3)/ n + 1)
  end
end
