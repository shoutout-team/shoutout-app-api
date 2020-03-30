module BackendHelper
  #include FontAwesome::Rails::IconHelper
  #include Pagy::Frontend

  # rubocop:disable Rails/HelperInstanceVariable
  def backend
    @backend ||= App::Backend.new(self)
  end
  # rubocop:enable Rails/HelperInstanceVariable

  # TODO: Replace this helper-soup using App::Backend
  def hosting_selector
    result = []
    env_urls = {
      preview: App::Config::PREVIEW_BACKEND,
      staging: App::Config::STAGING_BACKEND,
      production: App::Config::PRODUCTION_BACKEND
    }

    env_urls.delete(Rails.env.to_sym)

    env_urls.each do |env, url|
      result << link_to(env.to_s.titleize, url, class: 'dropdown-item', target: '_blank', rel: 'noopener')
    end
    safe_join(result)
  end

  # TODO: Unify with ComponentHelper
  def render_list_heading(relation, class_name: nil, count: true)
    backend.decorator.render_list_heading(relation, class_name: class_name, count: count)
  end

  # TODO: Unify with ComponentHelper
  def entity_list_heading(class_name, count = 0)
    backend.decorator.entity_list_heading(class_name, count)
  end

  # DEPRECATED
  def backend_heading_title(entity)
    return entity.model_name.human if entity.is_a?(Class) && entity.respond_to?(:model_name)

    humanized_name = entity.respond_to?(:model_name) ? "#{entity.model_name.human} " : ''
    details = entity.is_a?(ActiveRecord::Relation) ? "(#{entity.count})" : "'#{entity}'"
    "#{humanized_name}#{details}"
  end

  def backend_form_multiselect_field(form, attribute_sym, values)
    value = form.object.public_send(attribute_sym)
    selected_values = value.present? ? value.split(' ') : []
    options = { class: 'selectize-multiselect', multiple: true }
    form.input attribute_sym, collection: values, selected: selected_values, include_hidden: false, input_html: options
  end

  def result_count_details(result = [])
    # TODO: Kaminari-specific code #4
    #result.is_a?(Array) ? "#{result.size} Ergebnisse" : page_entries_info(result)
  end

  def render_backend_pagination(entries)
    render partial: 'layouts/backend/pagination', locals: { entries: entries }
  end
end
