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
        render_json(User.available)
      end

      def locations
        render_json(Location.all)
      end

      private def spa_load_response
        {
          keepers: User.fetchable,
          categories: Static::CATEGORIES,
          companies: Company.fetchable
        }
      end
    end
  end
end
