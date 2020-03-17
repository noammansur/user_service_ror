# frozen_string_literal: true

module Presenters
      class PrepareUserForJson
        attr_reader :user
  
        def initialize(user)
          @user = user
        end
  
        def generate
          {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email
          }
        end
      end
    end
  end
  