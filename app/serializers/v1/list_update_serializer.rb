module V1
  class ListUpdateSerializer < AppSerializer
    attributes :id, :establishment_id, :status, :notes, :created_at
  end
end
