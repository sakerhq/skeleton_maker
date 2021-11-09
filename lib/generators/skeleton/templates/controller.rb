class <%= prefixed_controller_class_name %>Controller < ApplicationController

  before_action :authenticate_user
  before_action :set_<%= singular_table_name %>, %i[show update destroy]

  def index
    @<%= plural_table_name %> = policy_scope(<%= class_name %>)
  end

  def show; end

  def create
    authorize <%= class_name %>
    <%= singular_table_name %>_form = <%= class_name %>Form.new(<%= "#{singular_table_name}_params" %>, current_user)

    if <%= singular_table_name %>_form.save
      @<%= singular_table_name %> = <%= singular_table_name %>_form.<%= singular_table_name %>
    else
      errors = <%= singular_table_name %>_form.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  def update
    authorize @<%= singular_table_name %>
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      render :update, status: :ok, team_connect: @team_connect
    else
      errors = <%= singular_table_name %>.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  def destroy
    authorize @<%= singular_table_name %>
    if @<%= orm_instance.destroy %>
      head :ok
    else
      errors = @<%= singular_table_name %>.errors.full_messages
      render json: { error: errors }, status: :bad_request
    end
  end

  private

    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = policy_scope(<%= class_name %>).find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: ["Not Authorized"] }, status: :unauthorized
    end

    def <%= "#{singular_table_name}_params" %>
      params.require(:<%= singular_table_name %>).permit(:<%= %>)
    end

end
