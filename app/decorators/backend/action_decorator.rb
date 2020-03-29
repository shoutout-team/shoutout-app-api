module Backend
  module ActionDecorator
    CONFIRM_TEXT = 'Diesen Eintrag löschen ?'.freeze
    ACTION_WORDINGS = Backend::Config::ACTION_WORDINGS
    BACKEND_ACTION_ICONS = Backend::Config::ACTION_ICONS

    def action_flash(action_name, result: false, error_msg: nil, wording: nil)
      action_sym = action_name.to_sym
      actions = Backend::Config::ACTION_MAP
      model_wording = wording || model_name.human
      entity_text = to_s&.concat(' ') || ''
      cause = errors[:base]&.first if respond_to?(:errors)

      if result
        h.flash[:notice] = "#{model_wording} #{entity_text}wurde #{actions[action_sym]}."
      else
        msg = error_msg || "#{model_wording} #{entity_text}konnte nicht #{actions[action_sym]} werden."
        msg += " Grund: #{cause}." if cause.present?
        h.flash[:error] = msg
      end

      result
    end

    def back_button(path = :back)
      action_button(:back, path: path)
    end

    # rubocop:disable Metrics/ParameterLists
    def action_button(type_sym, title: nil, path: nil, confirm: CONFIRM_TEXT, css_class: nil, params: {}, data: {})
      title ||= ACTION_WORDINGS[type_sym]
      path ||= h.public_send("entity_#{type_sym}_path".to_sym, params)
      style = action_button_default_style
      style.concat(' ' + css_class) if css_class.present?

      case type_sym
      when :destroy
        h.link_to(title, path, class: style, method: :delete, data: data.merge(confirm: confirm))
      else
        h.link_to(title, path, class: style, data: data)
      end
    end
    # rubocop:enable Metrics/ParameterLists

    # rubocop:disable Metrics/ParameterLists
    # TODO: IMPROVEMENT: Accept a symbol for :path, like :show, :edit, :destroy #166
    def action_icon(type_sym, path: nil, confirm: 'Diesen Eintrag löschen ?', css_class: nil, html_data: {}, target: '_self')
      icon = action_icon_for(type_sym)

      return if icon.nil?

      title ||= action_title_for(type_sym)
      path ||= h.public_send("entity_#{type_sym}_path".to_sym)
      style = action_icon_default_style
      style.concat(' ' + css_class) if css_class.present?

      confirm_text = confirm.presence if type_sym.eql?(:destroy)
      html_data[:confirm] = confirm_text if confirm_text.present?
      html_data[:backend_action] = type_sym

      action_icon_markup(type_sym, path, title, icon, style, html_data, target)
    end
    # rubocop:enable Metrics/ParameterLists

    # rubocop:disable Metrics/ParameterLists
    private def action_icon_markup(type_sym, path, title, icon, style, html_data, target = '_self')
      case type_sym
      when :destroy
        h.link_to(path, title: title, class: style, data: html_data, method: :delete, target: target) do
          h.content_tag(:i, '', class: "fas #{icon}")
        end
      else
        path = nil if path.is_a?(Symbol) # e.g. path = :popover

        h.link_to(path, title: title, class: style, data: html_data, target: target) do
          h.content_tag(:i, '', class: "fas #{icon}")
        end
      end
    end
    # rubocop:enable Metrics/ParameterLists

    private def action_button_default_style
      'btn btn-outline-secondary action-button'
    end

    private def action_icon_default_style
      'btn btn-outline-secondary action-icon'
    end

    private def action_icon_for(type)
      BACKEND_ACTION_ICONS[type]
    end

    private def action_title_for(type)
      ACTION_WORDINGS[type]
    end
  end
end
