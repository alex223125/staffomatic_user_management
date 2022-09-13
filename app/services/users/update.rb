module Services
  module Users
    class Update

      include Authenticatable

      ACTION = "Update existing user"

      attr_reader :errors

      def initialize(current_user, target_user, params)
        @current_user = current_user
        @target_user = target_user
        @params = params
      end

      def call
        if is_current_user?
          raise UserUpdatesHimselfError
        else
          ActiveRecord::Base.transaction do
            @target_user.update!(@params)
            Operation.create!(action: ACTION, user: current_user.email)
          end
        end
      rescue UserUpdatesHimselfError => e
        Rails.logger.error(e.message)
        @errors = e
      rescue ActiveRecord::ActiveRecordError => e
        Rails.logger.error(e.message)
        @errors = e
      end

    end
  end
end