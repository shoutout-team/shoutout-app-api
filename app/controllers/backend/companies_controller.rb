module Backend
  class CompaniesController <  BackendController
    PARAMS = %i[
      name title category
      postcode city street street_number latitude longitude
      user description notes cr_number user_id
    ].freeze


    before_action :load_company, only: %i[approve reject]

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
    end

    def create
      @entity = Company.create(company_params).try(:decorate)

      if @entity.persisted?
        redirect_to root_path
      else
        render :add
      end
    end

    private def company_params
      allowed = PARAMS + [Company.property_params]
      params.require(:company).permit(*allowed)
    end

    private def load_company
      @company = Company.find(params[:id])
    end
  end
end
