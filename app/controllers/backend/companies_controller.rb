module Backend
  class CompaniesController < BackendController
    include UploadPostProcessing

    PARAMS = %i[
      name title category
      postcode city street street_number latitude longitude
      user user_id
    ].freeze

    before_action :require_company, only: %i[approve reject edit update]

    def index
      @entities = Company.list
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
        process_changed_picture
        redirect_to backend_list_companies_path
      else
        render :form
      end
    end

    def update
      if @entity.update(company_params)
        process_changed_picture
        redirect_to backend_list_companies_path
      else
        render :form
      end
    end

    def approve
      @company.update(approved: true)
      redirect_to root_path
    end

    def reject
      @company.update(approved: false)
      redirect_to root_path
    end

    private def process_changed_picture
      return if @entity.picture_key_before_last_save.eql?(company_params[:picture_key])

      if company_params[:picture_key].blank?
        @entity.update(picture: nil)
      else
        remap_upload(company_params[:picture_key], @entity, :picture)
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
