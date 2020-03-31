module Api
  module V1
    class CompaniesController < Api::BaseController
      include UploadPostProcessing

      PARAMS = %i[
        name title category
        postcode city street street_number latitude longitude
        picture_key change_picture
      ].freeze

      before_action :require_keeper, only: %i[fetch create update approve]
      after_action :verify_authorized, only: %i[create update]

      def fetch
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?
        return render_json_forbidden(:company_not_present) if @keeper.company.nil?

        render_json(result: @keeper.company)
      end

      # TODO: Problem: when asynchrounus processing is integrated, then rendering asset with attached-check on asset
      # in model (e.g. has_picture?) will not provide the attachment_key! #31
      def create
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?
        return render_json_forbidden(:company_already_present) if @keeper.company.present?

        @company = Company.create(company_params.merge(user: @keeper))

        if @company.persisted?
          post_process_asset_for(@company, kind: :picture)
          render_json(result: @company)
        else
          render_json_unprocessable(error: :invalid, issues: @company.errors.details)
        end
      end

      def update
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?

        @company = @keeper.company

        return render_json_forbidden(:unapproved_company) unless @company.approved?

        if @company.update_with_picture(company_params)
          replace_asset_for(@company, kind: :picture) if @company.update_picture?
          render_json(result: @company)
        else
          render_json_unprocessable(error: :invalid, issues: @company.errors.details)
        end
      end

      # TODO: This endpoint must be restricted to dev-clients #43
      def approve
        return render_json_forbidden(:unknown_keeper) if @keeper.nil?
        return render_json_forbidden(:company_not_present) if @keeper.company.nil?

        @company = @keeper.company

        if @company.update(approved: true)
          render_json
        else
          render_json_unprocessable(error: :invalid, issues: @company.errors.details)
        end
      end

      private def company_params
        allowed = PARAMS + [Company.property_params]
        params.require(:company).permit(*allowed)
      end

      private def token
        params[:keeper_token] || params[:company].try(:[], :keeper_token)
      end

      private def require_keeper
        @keeper = User.available.find_by(gid: token)
      end
    end
  end
end
