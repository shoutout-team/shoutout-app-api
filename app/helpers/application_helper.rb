module ApplicationHelper
  def current_layout
    layout_name = controller.class.send(:_layout)

    if layout_name.nil?
      :application
    elsif layout_name.eql?(:resolve_layout)
      public_send(layout_name)
    elsif layout_name.instance_of?(String) || layout_name.instance_of?(Symbol)
      layout_name.to_s.parameterize
    else
      File.basename(layout_name.identifier).split('.').first
    end
  end

  # TODO: This does not work, cause we need to capture child-content with 'yield'
  # https://github.com/slim-template/slim/issues/323
  def body_tag
    data = { controller: params[:controller], action: params[:action], env: Rails.env }
    content_tag(:body, '', id: current_layout, class: body_styles, data: data)
  end

  def body_attributes
    data = { controller: params[:controller].parameterize, action: params[:action], env: Rails.env }
    { id: current_layout, class: body_styles, data: data }
  end

  def body_styles(classes = [])
    classes.concat(browser_styles)
    classes.push(Rails.env)
    classes.compact.join(' ')
  end
end
