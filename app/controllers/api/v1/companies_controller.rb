module Api
  module V1
    class CompaniesController < Api::BaseController
      include UploadPostProcessing

      PARAMS = %i[name title category postcode city street street_number latitude longitude picture_key].freeze

      before_action :require_keeper, only: %i[create update]

      # TODO: Problem: when asynchrounus processing is integrated, then rendering asset with attached-check on asset
      # in model (e.g. has_picture?) will not provide the attachment_key! #31
      def create
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?

        @company = Company.create(company_params.merge(user: @keeper))

        if @company.persisted?
          post_process_asset_for(@company, kind: :picture)
          render_json(result: @company)
        else
          render_json_unprocessable(:invalid, @company.errors)
        end
      end

      def update
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?

        if (@company = Company.update(company_params))
          render_json(result: @company)
        else
          render_json_unprocessable(:invalid, @company.errors)
        end
      end

      private def company_params
        allowed = PARAMS + [Company.property_params]
        params.require(:company).permit(*allowed)
      end

      private def token
        params[:keeper_token] || params[:company][:keeper_token]
      end

      private def require_keeper
        @keeper = User.available.find_by(gid: token)
      end
    end
  end
end
