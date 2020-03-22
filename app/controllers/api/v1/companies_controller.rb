module Api
  module V1
    class CompaniesController < Api::BaseController
      PARAMS = %i[name title category postcode city street street_number latitude longitude].freeze

      before_action :require_keeper

      def create
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?

        @company = Company.create(company_params.merge(user: @keeper))
        @company.persisted? ? render_json(result: @company) : render_json_unprocessable(:invalid, @company.errors)
      end

      private def company_params
        params.require(:company).permit(*PARAMS)
      end

      private def token
        params[:company][:keeper_token]
      end

      private def require_keeper
        @keeper = User.available.find_by(token: token)
      end
    end
  end
end
