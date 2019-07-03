require 'zxcvbn'

# frozen_string_literal: true

module PasswordPolice
  class CalculateStrength
    def self.check_strength(plaintext_pwd)
      Zxcvbn.test(plaintext_pwd).score
    end
  end
end
