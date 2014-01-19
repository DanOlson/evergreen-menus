module V1
  class AppSerializer < ActiveModel::Serializer
    attribute :errors

    def include_errors?
      object.errors.any?
    end
  end
end
