json.array! @<%= plural_table_name %> do |<%= singular_table_name %>|
  json.cache! <%= singular_table_name %> do
    json.extract! <%= singular_table_name %>, :id
  end
end
