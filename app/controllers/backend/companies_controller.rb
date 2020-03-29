module Backend
  class CompaniesController <  BackendController
    before_action :load_company, only: %i[approve reject]

    def approve
      @company.update(approved: true)
      redirect_to root_path
    end

    def reject
      @company.update(approved: false)
      redirect_to root_path
    end

    private def load_company
      @company = Company.find(params[:id])
    end
  end
end
