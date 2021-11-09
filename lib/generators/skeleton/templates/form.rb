class <%= class_name %>Form < ApplicationForm

  # NOTE: Attributes
  attr_accessor :parameter

  delegate :id, :persisted?, to: :<%= singular_table_name %>

  def self.model_name
    ActiveModel::Name.new(self, nil, "<%= class_name %>")
  end

  def save
    ActiveRecord::Base.transaction do
      @<%= singular_table_name %> = <%= class_name %>.create!(<%= "#{singular_table_name}_params" %>)
    end
  rescue ActiveRecord::Rollback, ActiveRecord::RecordInvalid => e
    collect_errors(@<%= singular_table_name %>)
    false
  end

  private

    def <%= "#{singular_table_name}_params" %>
      {
        parameter: value
      }.compact
    end

end
