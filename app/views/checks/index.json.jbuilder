json.array!(@checks) do |check|
  json.extract! check, :id, :name, :url
  json.url check_url(check, format: :json)
end
