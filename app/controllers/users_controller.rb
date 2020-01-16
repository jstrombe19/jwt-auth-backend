require 'pry'

class UsersController < ApplicationController

    def create
        @user = User.create(user_params)
        render json: @user 
    end

    def index
       @users = User.all
       render json: @users  
    end

    def profile
       authorization_header = request.headers[:authorization]
       if !authorization_header
        render status: :unauthorized
       else
        token = authorization_header.split(" ")[1]
        secret_key = Rails.application.secrets.secret_key_base[0]
        decoded_token = JWT.decode(token, secret_key)
        user = User.find(decoded_token[0]["user_id"])
        render json: user 
       end
    end

    private

    def user_params 
        params.require(:user).permit([:name, :username, :email, :password])
    end

end
