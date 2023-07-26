# frozen_string_literal: true

# User Partial
json.id user.id
json.provider user.provider
json.uid user.uid
json.allow_password_change user.allow_password_change
json.name user.name
json.nickname user.nickname
json.image user.image
json.email user.email
json.phone user.phone
json.created_at user.created_at
json.updated_at user.updated_at
json.varified_user user.varified_user
json.personal_detail user.personal_detail
json.roles user.roles
profileImageUrl = user.profile.present? ? url_for(user.profile) : ''
if profileImageUrl.present?
  urlStartPoint, urlEndPoint = [profileImageUrl.index('/rails/'), profileImageUrl.length]
  profileImageUrl = request.base_url + profileImageUrl[urlStartPoint..urlEndPoint]
end
json.profile_path profileImageUrl
json.store user.stores do |store|
  json.partial! '/api/v1/stores/store', store: store
end
