json.cache! @<%= singular_table_name %> do 
  json.partial! "<%= singular_table_name %>", <%= singular_table_name %>: @<%= singular_table_name %>
end