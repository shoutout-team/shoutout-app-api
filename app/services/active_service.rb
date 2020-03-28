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

  protected def fail_with(error_key, msg = nil)
    @error = error_key
    @issues = msg.presence
    @success = false
  end

  protected def fail_with!(error_key)
    fail_with(error_key)

    raise ProcessingFailed
  end

  protected def issues_from_record_for(record, attr_key)
    { details: record.errors.details[attr_key], messages: record.errors.messages[attr_key] }
  end
end
