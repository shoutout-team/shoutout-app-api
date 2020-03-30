module Backend
  class CompaniesController < BackendController
    PARAMS = %i[
      name title category
      postcode city street street_number latitude longitude
      user user_id
    ].freeze

    before_action :require_company, only: %i[approve reject edit update]

    def approve
      @company.update(approved: true)
      redirect_to root_path
    end

    def reject
      @company.update(approved: false)
      redirect_to root_path
    end

    def add
      @entity = Company.new.decorate
      render :form
    end

    def edit
      render :form
    end

    def create
      @entity = Company.create(company_params).try(:decorate)

      if @entity.persisted?
        redirect_to root_path
      else
        render :form
      end
    end

    def update
      if @entity.update(company_params)
        redirect_to root_path
      else
        render :form
      end
    end

    private def company_params
      allowed = PARAMS + [Company.property_params[:properties]]
      params.require(:company).permit(*allowed)
    end

    private def require_company
      @company = Company.find(params[:id])
      @entity = @company.decorate
    end
  end
end
