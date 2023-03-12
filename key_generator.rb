class KeyGenerator
  def self.call(...) = new(...).call

  def initialize(length:)
    @length = length
  end

  def call
    key = rand(2**(length - 1)...2**length)
  end

  private

  attr_reader :length
end
