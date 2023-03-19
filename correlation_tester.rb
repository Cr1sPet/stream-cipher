class CorrelationTester
  def self.call(...) = new(...).call

  def initialize(m_sequence:)
    @ks = [1, 2, 8, 9]
    @r = {}
    @m_seq = m_sequence
    @n = m_seq.length
  end

  def call
    correlation_test
    puts 'Корреляционный тест пройден!'
    rescue RuntimeError => er
      puts "Кореляционный тест провален!"
      puts er.message
  end

  private

  attr_reader :m_seq, :ks, :r, :n

  def correlation_test
    ks.each do |k|
      correlation_coefficient(k)
      if r_border < correlation_coefficient(k)
        raise RuntimeError.new("Коэффициент коррреляции при k == #{k} превышает граничное значение ")
      end
    end
  end

  def correlation_coefficient(k)
      m_i = m_seq[0..-k-1].sum.to_f / (m_seq.length - k)
      m_i_k = m_seq[k..-1].sum.to_f / (m_seq.length - k)

      d_i = m_seq[0..-k-1].inject(0) { |sum, x| sum + (x.to_f - m_i)**2 } / (m_seq.length - k - 1)
      d_i_k = m_seq[k..-1].inject(0) { |sum, x| sum + (x.to_f - m_i_k)**2 } / (m_seq.length - k - 1)

      r[k] = m_seq.each_cons(k + 1).inject(0) { |sum, pair| sum + (pair[0].to_f - m_i) * (pair[k].to_f - m_i_k) } / (m_seq.length - k)
      r[k] /= Math.sqrt(d_i * d_i_k)
      r[k] = r[k].abs
  end

  def r_border
    1.0 / (n - 1) + (2.0 / (n - 2)) * Math.sqrt(n * (n - 3)/ n + 1)
  end
end
