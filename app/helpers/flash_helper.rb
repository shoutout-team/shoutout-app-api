module FlashHelper
  def flash_class_for_key(key)
    case key.to_sym
    when :alert
      :'alert-warning'
    when :error
      :'alert-danger'
    when :notice
      :'alert-success'
    else
      :'alert-info'
    end
  end
end
