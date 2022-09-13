class UsersController < ApplicationController

  before_action :set_target_user, only: %i[ update ]

  def index
    render jsonapi: User.all
  end

  def update
    service = Services::Users::Update.new(current_user, @target_user,
                                          contact_params)
    service.call

    if service.errors.blank?
      render jsonapi: service.target_user
    else
      render jsonapi_errors: { detail: service.errors.message }, status: :unprocessable_entity
    end
  end

  private

  def set_target_user
    @target_user = User.find(params[:id])
  end

  def contact_params
    params.require(:user).permit(:email, :is_archived)
  end

end
