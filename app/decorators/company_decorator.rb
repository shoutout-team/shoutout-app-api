class CompanyDecorator < BackendDecorator
  def category_collection
    Company::CATEGORIES.keys
  end
end
