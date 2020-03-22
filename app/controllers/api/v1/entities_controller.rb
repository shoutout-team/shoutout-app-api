module Api
  module V1
    class EntitiesController < Api::BaseController
      def load
        render_json(spa_load_response)
      end

      def companies
        render_json(Company.available)
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
          companies: Company.available
        }
      end
    end
  end
end
