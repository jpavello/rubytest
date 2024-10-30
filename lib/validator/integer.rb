module Validator
  class Integer < Base
    self::REFERENCE_CLASS = ::Integer
    self::ERROR_MESSAGE   = 'not_an_integer'
  end
end
