module V1
  class ApiKeySerializer < AppSerializer
    attributes :user_id, :access_token
  end
end
