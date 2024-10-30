module Validator
  class Numeric < Base
    self::REFERENCE_CLASS = ::Numeric
    self::ERROR_MESSAGE   = 'not_a_number'
  end
end
