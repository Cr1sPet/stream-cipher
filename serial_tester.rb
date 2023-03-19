class SerialTester
  def self.call(...) = new(...).call

  def initialize(m_sequence:, block_length:)
    @m_sequence = m_sequence
    @block_length = block_length
    @criteries = [(0.584..6.251), (2.833..12.017), (8.547..22.307)]
  end

  def call
    serial_test()
  end


  private


  attr_reader :m_sequence, :block_length, :criteries

  def pirson_criterion(psi, k)
    result = case k
             when 2
               criteries[0].include?(psi)
             when 3
              criteries[1].include?(psi)
             when 4
              criteries[2].include?(psi)
             else
               raise ArgumentError.new('размер блока должен принадлжеить интервалу от 2 до 4')
             end
    unless result
      raise RuntimeError.new("Хи #{psi} не попадает в необходимый интервал #{criteries[block_length - 2]} при k == #{block_length}")
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

  def serial_test
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

    # puts m_series_counts
    # puts m_series_frequencies
    # puts theoretical_n
    # puts psi
    begin
      pirson_criterion(psi, block_length)
      puts "Хи #{psi} попадает в необходимый интервал #{criteries[block_length - 2]} при k == #{block_length}"
      puts 'Сериальный тест пройден!'
      rescue RuntimeError => err
        puts err.message
    end
  end
end
