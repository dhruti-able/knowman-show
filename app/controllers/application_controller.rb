class ApplicationController < ActionController::API
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end    

    def current_user?(user)
        current_user == user
    end

    def current_user_admin?
        current_user && current_user.admin?
    end

    def require_signin
        unless current_user
          session[:intended_url] = request.url
          render json: { "@errors": "please sign in first!" }, status: :unprocessable_entity
        end
    end

    def require_admin
        unless current_user_admin?
            render json: { "@errors": "unauthorized access!" }, status: :unprocessable_entity
        end
    end
end
