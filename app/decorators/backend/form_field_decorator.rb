module Backend
  module FormFieldDecorator
    def form_return_field(return_to_value = nil)
      @form.input :return_to, as: :hidden, input_html: { name: 'return_to', value: return_to_value }
    end

    def form_author_field
      @form.input :created_by, as: :hidden, input_html: { value: h.current_user.id } if @form.object.new_record?
    end

    def form_editor_field
      @form.input :updated_by, as: :hidden, input_html: { value: h.current_user.id } unless @form.object.new_record?
    end

    def form_active_field
      @form.input :active, label: false, input_html: { data: { toggle: 'active-switch' } }
    end

    def form_permission_field
      input_html = { multiple: true, class: 'multiselect-field' }
      wrapper_html = { class: 'permission-selector' }
      @form.input :permissions, collection: permission_map, input_html: input_html, wrapper_html: wrapper_html
    end

    def form_boolean_select_field(field_name)
      collection = [['Ja', true], ['Nein', false]]
      @form.input field_name, collection: collection, prompt: false
    end

    def form_checkbox_field(field_name, default_value: nil)
      return @form.input field_name, as: :boolean if default_value.nil?

      default_value = new_record? ? default_value : boolean_object_value_for(field_name)
      @form.input field_name, as: :boolean, input_html: { checked: default_value }
    end

    private def boolean_object_value_for(field_name)
      value = @form.object.public_send(field_name)

      return false if value.nil?
      return false if value.eql?('0')
      return true if value.eql?('1')
      return true if value.eql?(true)
    end
  end
end
