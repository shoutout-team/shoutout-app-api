class ActiveService
  include ActiveModel::Validations
  extend ActiveModel::Callbacks

  METHODS = [].freeze

  class UnknownServiceMethod < StandardError; end
  class MissingParams < StandardError; end
  class ProcessingFailed < StandardError; end

  def self.check_service_method!(method_name)
    raise UnknownServiceMethod unless self::METHODS.include?(method_name)
  end

  protected def fail_with!(error_key)
    @error = error_key

    raise ProcessingFailed
  end
end
