module Backend
  module TableDecorator
    def table_list_styles
      'table table-sm table-striped table-hover backend-table sortable'
    end

    def backend_table_tag(styles: '', &block)
      table_content = h.capture(&block) if block
      h.content_tag(:table, table_content, class: table_list_styles.concat(' ' + styles))
    end

    def clickable_table_row_tag(path = nil, target: '_self', &block)
      table_content = h.capture(&block) if block
      path ||= h.public_send("backend_#{model_name.singular_route_key}_path", self)
      data = { href: path, name: to_s, target: target }
      h.content_tag(:tr, table_content, class: 'clickable-table-row', data: data)
    end

    def sortable_date_table_cell_tag(attr_name, format: 'DD-MM-YYYY', styles: '')
      h.content_tag(:td, public_send(attr_name), class: styles, data: { dateformat: format })
    end
  end
end
