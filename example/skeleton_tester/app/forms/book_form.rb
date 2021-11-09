class BookForm < ApplicationForm

  # NOTE: Attributes
  attr_accessor :parameter

  delegate :id, :persisted?, to: :book

  def self.model_name
    ActiveModel::Name.new(self, nil, "Book")
  end

  def save
    ActiveRecord::Base.transaction do
      @book = Book.create!(book_params)
    end
  rescue ActiveRecord::Rollback, ActiveRecord::RecordInvalid => e
    collect_errors(@book)
    false
  end

  private

    def book_params
      {
        parameter: value
      }.compact
    end

end
