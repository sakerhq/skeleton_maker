json.array! @books do |book|
  json.cache! book do
    json.extract! book, :id
  end
end
