module Api
  class V1Controller < ApplicationController
    def companies
      render_json(Company.active)
    end

    def categories
      render_json(Static::CATEGORIES)
    end

    def keepers
      render_json(User.available.pluck(:id, :email, :name))
    end
  end
end
