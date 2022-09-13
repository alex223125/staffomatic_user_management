module Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user, :target_user

    private

    def is_current_user?
      current_user == target_user
    end
  end

end