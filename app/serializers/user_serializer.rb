class UserSerializer
  include JSONAPI::Serializer
  attributes :email, :is_archived
end
