module Api
  class V1Controller < ApplicationController
    def load
      render_json(spa_load_response)
    end

    def companies
      render_json(Company.active)
    end

    def categories
      render_json(Static::CATEGORIES)
    end

    def keepers
      render_json(User.available.pluck(:id, :email, :name))
    end

    private def spa_load_response
      {
        keepers: User.available.pluck(:id, :email, :name),
        categories: Static::CATEGORIES,
        companies: Company.active
      }
    end
  end
end
