require 'date'

module Validator
  class Date < Base
    self::REFERENCE_CLASS = ::Date
    self::ERROR_MESSAGE   = 'not_a_date'
  end
end
