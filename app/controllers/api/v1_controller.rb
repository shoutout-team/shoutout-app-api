module Api
  class V1Controller < ApplicationController
    def companies
      render_json(Company.active)
    end

    def categories
      render_json(Static::CATEGORIES)
    end
  end
end
