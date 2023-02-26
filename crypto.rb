# frozen_string_literal: true

module StreamCipher
  class Crypto
    SETUP = 31

    def generate_key
      value = SETUP
      puts value.size
      l = 4
      s =
        result = 0
      4.times do
        puts((value[4 - l] ^ value[4 - s]))
      end
      result
    end
  end
end
