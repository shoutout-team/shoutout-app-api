# TODO: Rename me to AttributeDecoration #133
module Backend
  module BaseDecorator
    def no_value
      BackendDecorator::NO_VALUE
    end

    def boolean_as_text(attr_name)
      public_send(attr_name) ? 'Ja' : 'Nein'
    end

    def boolean_icon(attr_name)
      public_send(attr_name).eql?(true) ? h.fa_icon('check') : h.fa_icon('times')
    end

    def active_value
      boolean_as_text(:active)
    end

    def active_icon
      respond_to?(:active) ? boolean_icon(:active) : nil
    end

    def local_date_value(attr_name, date_format = :german_with_time)
      value = public_send(attr_name)
      I18n.l(value, format: date_format) if value.present?
    end
  end
end
