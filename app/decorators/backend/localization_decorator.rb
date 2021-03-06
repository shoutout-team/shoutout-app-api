module Backend
  module LocalizationDecorator
    def created_at_value
      local_date_value(:created_at)
    end

    def updated_at_value
      local_date_value(:updated_at)
    end

    def created_info
      "Created: #{created_at_value}"
    end

    def updated_info
      "Updated: #{updated_at_value}"
    end
  end
end
