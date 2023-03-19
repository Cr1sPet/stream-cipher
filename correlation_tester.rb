class CorrelationTester
  def self.call(...) = new(...).call

  def initialize(m_sequence:)
    @ks = [1, 2, 8, 9]
    @m_seq = m_sequence
    @n = m_seq.length
  end

  def call
    correlation_test
    puts 'Корреляционный тест пройден!'
    rescue RuntimeError => er
      puts er.message
  end

  private

  attr_reader :m_seq, :ks, :r, :n
  attr_writer :r

  def correlation_test
    ks.each do |k|
      koff = correlation_coefficient(k)
      if r_border < koff
        puts "Коэффициент коррреляции `#{koff}` при k == #{k} превышает граничное значение `#{r_border}`"
      else
        puts "Коэффициент корреляции #{koff} при k == #{k} в норме. Граничное значение: #{r_border}"
      end
    end
  end

  def correlation_coefficient(k)
    m_i = m_seq[0..-k-1].sum.to_f / (m_seq.length - k)
    m_i_k = m_seq[k..-1].sum.to_f / (m_seq.length - k)

    d_i = m_seq[0..-k-1].inject(0) { |sum, x| sum + (x.to_f - m_i)**2 } / (m_seq.length - k - 1)
    d_i_k = m_seq[k..-1].inject(0) { |sum, x| sum + (x.to_f - m_i_k)**2 } / (m_seq.length - k - 1)

    r = 0.0
    (m_seq.length - k).times do |i|
      r += (m_seq[i] - m_i) * (m_seq[i+k] - m_i_k)
    end
    r /= (m_seq.length - k)
    r /= Math.sqrt(d_i * d_i_k)
    r.abs
  end

  def r_border
    @r_border ||= 1.0 / (n - 1) + (2.0 / (n - 2)) * Math.sqrt(n * (n - 3)/ n + 1)
  end
end
