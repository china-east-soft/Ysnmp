json.array!(@rules) do |rule|
  json.extract! rule, :id, :name, :frequency, :method, :data
  json.url rule_url(rule, format: :json)
end
