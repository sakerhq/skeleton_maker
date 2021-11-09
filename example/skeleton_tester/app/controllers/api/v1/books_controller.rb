class Api::V1::BooksController < ApplicationController

  before_action :authenticate_user
  before_action :set_book, %i[show update destroy]

  def index
    @books = policy_scope(Book)
  end

  def show; end

  def create
    authorize Book
    book_form = BookForm.new(book_params, current_user)

    if book_form.save
      @book = book_form.book
    else
      errors = book_form.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  def update
    authorize @book
    if @book.update(book_params)
      render :update, status: :ok, team_connect: @team_connect
    else
      errors = book.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  def destroy
    authorize @book
    if @book.destroy
      head :ok
    else
      errors = @book.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  private

    def set_book
      @book = policy_scope(Book).find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: ["Not Authorized"] }, status: :unauthorized
    end

    def book_params
      params.require(:book).permit(:)
    end

end
