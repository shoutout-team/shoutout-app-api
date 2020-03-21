module FlashHelper
  def class_for_flash_key(type)
    case type.to_sym
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

  def frontend_class_for_flash_key(type)
    case type.to_sym
    when :alert
      'alert __warning'
    when :error
      'alert __danger'
    when :notice
      'alert __success'
    else
      'alert __info'
    end
  end
end
