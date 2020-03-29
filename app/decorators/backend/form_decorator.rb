module Backend
  module FormDecorator
    attr_accessor :form

    # TODO: Rename :form to :form_builder #131 #133 #121
    def backend_form_tag(model_key: nil, styles: nil)
      model_key ||= form_model_key
      form_html = form_tag_html(model_key, styles)

      h.simple_form_for(self, as: model_key, url: form_url_path, html: form_html) do |f|
        # NOTE: f.class := SimpleForm::FormBuilder
        self.form = f
        yield(f)
      end
    end

    def form_tag_html(model_key = nil, styles = nil)
      { id: form_html_id(model_key), class: "backend-form #{form_model_key.dasherize} #{styles}".strip }
    end

    def form_html_id(model_key = nil)
      if model_key.present?
        new_record? ? "new_#{model_key}" : "edit_#{model_key}"
      else
        new_record? ? "new_#{form_model_key}" : "edit_#{form_model_key}_#{id}"
      end
    end

    def form_model_key
      model_name.singular_route_key
    end

    def form_routing_key(alt_routing_key = nil)
      alt_routing_key || model_name.route_key
    end

    def form_title(title_method = :to_s)
      new_record? ? "#{model_name.human} erstellen" : "#{model_name.human} '#{public_send(title_method)}' bearbeiten"
    end

    def form_url_path(alt_routing_key = nil)
      route_key = form_routing_key(alt_routing_key)
      new_record? ? form_create_path(route_key) : form_update_path(route_key)
    end

    def form_create_path(routing_key = nil)
      routing_key ||= form_routing_key
      h.public_send("backend_#{routing_key}_path".to_sym)
    end

    def form_update_path(routing_key = nil)
      routing_key ||= form_routing_key
      h.public_send("backend_#{routing_key.to_s.singularize}_path".to_sym, self)
    end

    def form_submit_button(return_back: false)
      button_name = return_back ? 'commit_and_return' : 'commit'
      new_text = return_back ? 'Erstellen' : 'Erstellen und schliessen'
      save_text = return_back ? 'Speichern' : 'Speichern und schliessen'
      label = new_record? ? new_text : save_text
      @form.button :submit, label, name: button_name, class: 'btn btn-outline-secondary'
    end

    def form_html
      { class: 'backend-form' }
    end
  end
end
