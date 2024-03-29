class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    user.tags.build(tag: params[:tag])

    if user.save
      render json: user, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :full_name, tags_attributes: :tag)
  end
end