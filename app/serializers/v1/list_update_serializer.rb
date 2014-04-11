module V1
  class ListUpdateSerializer < AppSerializer
    attributes :id, :establishment_id, :name, :status, :raw_data, :notes, :created_at

    def name
      object.establishment.name
    end
  end
end
