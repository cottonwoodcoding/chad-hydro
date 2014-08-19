json.array!(@profiles) do |profile|
  json.extract! profile, :id, :customer_id, :address, :order_ids
  json.url profile_url(profile, format: :json)
end
