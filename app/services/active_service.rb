class ActiveService
  include ActiveModel::Validations
  extend ActiveModel::Callbacks

  METHODS = [].freeze

  attr_accessor :succees, :error, :issues

  class UnknownServiceMethod < StandardError; end
  class MissingParams < StandardError; end
  class ProcessingFailed < StandardError; end

  def self.check_service_method!(method_name)
    raise UnknownServiceMethod unless self::METHODS.include?(method_name)
  end

  def succeeded?
    @success
  end

  def failed?
    @error.present?
  end

  protected def succees!
    @success = true
  end

  protected def fail_with(error_key)
    @error = error_key
    @success = false
  end

  protected def fail_with!(error_key)
    fail_with(error_key)

    raise ProcessingFailed
  end

  protected def issues_from_record_for(attr_key)
    { details: e.record.errors.details[attr_key], messages: e.record.errors.messages[attr_key] }
  end
end
