# frozen_string_literal: true

module Contexts
  module Users
    class UserContext
      def register(params)
        user = User.new(user_params(params))
        user.email.downcase!
        user.save
        user
      end

      def update(params)
        user = User.find_by_id(params[:id])
        user.update(user_params(params))
        user
      end

      def sign_in(email, password, session)
        user = User.find_by(email: email.downcase)
        return nil unless user&.authenticate(password)

        token = SecureRandom.hex(10)
        session[:session_token] = token
        user.update(token: token)
        user
      end

      def sign_out(session)
        session.delete(:session_token)
      end

      private

      def user_params(params)
        params.permit(:first_name, :last_name, :email, :password)
      end
    end
  end
end
