class UploadDecorator < BackendDecorator
  def entity_collection
    %i[user company]
  end

  def kind_collection
    %i[avatar picture]
  end
end
