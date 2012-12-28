module Soulmate
  class Normalizer
    def self.call(str)
      str.downcase.gsub(/[^a-z0-9 ]/i, '').strip
    end
  end
end
