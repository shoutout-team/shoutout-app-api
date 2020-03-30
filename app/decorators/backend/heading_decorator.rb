module Backend
  module HeadingDecorator
    # rubocop:disable Metrics/ParameterLists
    # rubocop:disable Layout/LineLength

    def entity_list_heading(class_name, count = 0)
      human_name = class_name.model_name.human(count: count)
      count.present? ? "#{count} #{human_name}" : human_name
    end

    def render_list_title(title)
      options = {
        heading: h.content_tag(:h1, title, class: 'heading'),
        component_style: nil,
        first_column_class: 'col-12',
        sub_heading: false,
        features: [],
        actions: {}
      }

      h.render partial: 'layouts/backend/components/heading', locals: options
    end

    # TODO: Adpot features and actions from controller
    def render_list_heading(relation, class_name: nil, size: nil, count: true, features: [], actions: {})
      return if relation.nil?

      class_name ||= relation.klass
      size ||= relation.size
      model_name = class_name.model_name
      human_name = model_name.human(count: count ? size : 2) # '2' := Plural by default for list-headings
      render_entity_heading(heading: human_name, count: (count ? size : nil), model_name: model_name, features: features, actions: actions)
    end

    def render_plain_heading(class_name, text: nil, count: nil)
      render_entity_heading(heading: text, count: count, model_name: class_name.model_name)
    end

    # def render_custom_list_heading(relation, class_name: nil, size: nil, count: true, features: [], actions: {})
    #   return if relation.nil?

    #   class_name ||= relation.klass
    #   size ||= relation.size
    #   model_name = class_name.model_name
    #   human_name = model_name.human(count: count ? size : 2) # '2' := Plural by default for list-headings
    #   render_entity_heading(heading: human_name, count: (count ? size : nil), model_name: model_name, features: features, actions: actions)
    # end

    def render_show_heading
      render_entity_heading(heading: to_s)
    end

    def render_form_heading(title_method = :to_s)
      render_entity_heading(heading: form_title(title_method))
    end

    def render_entity_heading(heading: nil, heading_element: 'h1', heading_style: 'heading', count: nil, model_name: nil, features: [], actions: {})
      heading_title = count.present? ? "#{count} #{heading}" : heading
      first_column_class = features.include?(:search) ? 'col-6' : 'col-10'

      options = {
        heading: h.content_tag(heading_element, heading_title, class: heading_style),
        component_style: (model_name || self.model_name).param_key,
        first_column_class: first_column_class,
        sub_heading: false,
        count: count,
        features: features,
        actions: actions
      }

      h.render partial: 'layouts/backend/components/heading', locals: options
    end

    # rubocop:enable Metrics/ParameterLists
    # rubocop:enable Layout/LineLength
  end
end
