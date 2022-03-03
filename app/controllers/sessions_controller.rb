class SessionsController < ApplicationController
    def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
        else
            render json: user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        session[:user_id] = nil
    end
end
