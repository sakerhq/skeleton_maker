# frozen_string_literal: true

class Create<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %><%= primary_key_type %> do |t|
      
      t.timestamps null: false
    end
  end
end