# frozen_string_literal: true

# Store Partial JSON
json.id store.id
json.title store.title
json.description store.description
json.status store.status
json.address store.address
json.created_at store.created_at
json.updated_at store.updated_at
# json.profile_image store.profile_image.present? ? url_for(store.profile_image.variant(resize_to_limit: [400, 400]).processed) : nil
# json.cover_image store.cover_image.present? ? url_for(store.cover_image.variant(resize_to_limit: [400, 400]).processed) : nil
profileImageUrl = store.profile_image.present? ? url_for(store.profile_image) : ''
if profileImageUrl.present?
  urlStartPoint, urlEndPoint = [profileImageUrl.index('/rails/'), profileImageUrl.length]
  profileImageUrl = request.base_url + profileImageUrl[urlStartPoint..urlEndPoint]
end
json.profile_image_path profileImageUrl
coverImageUrl = store.cover_image.present? ? url_for(store.cover_image) : ''
if coverImageUrl.present?
  urlStartPoint, urlEndPoint = [coverImageUrl.index('/rails/'), coverImageUrl.length]
  coverImageUrl = request.base_url + coverImageUrl[urlStartPoint..urlEndPoint]
end
json.cover_image_path coverImageUrl
json.user_id store.user_id
