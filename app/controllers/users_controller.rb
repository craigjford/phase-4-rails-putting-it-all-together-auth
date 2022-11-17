class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    def create 
        user = User.create!(user_params)
        session[:user_id] = user.id   
        render json: user, status: :created

    end

    def show    
        # user = User.find_by(id: session[:user_id])
        user = User.find_by(username: params[:username])
        # if user&.authenticate(params[:password])    
        if user
            render json: user, status: :created
        else
            render json: { errors: "No current session stored" }, status: :unauthorized
        end  

        # if session[:user_id] == nil 
        #     render json: { errors: "No current session stored" }, status: :unauthorized
        # else
        #     user = User.find_by(id: session[:user_id])
        #     # if user&.authenticate(params[:password])
        #     if user    
        #         render json: user, status: :created
        #     else
        #         render json: { errors: "No current session stored" }, status: :unauthorized
        #     end    
        # end
    end

    private

    def user_params 
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def render_unprocessable_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

end
