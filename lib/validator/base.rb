module Validator
  class Base
    REFERENCE_CLASS = nil
    ERROR_MESSAGE   = ''

    def self.validate(object, attribute, value_range = nil)
      object.errors.push({ attribute => self::ERROR_MESSAGE }) unless object.send(attribute).is_a?(self::REFERENCE_CLASS)
      object.errors.push({ "#{attribute}_value" => 'invalid_value' }) if value_range.is_a?(Range) and not value_range.include?(object.send(attribute))
    end
  end
end
