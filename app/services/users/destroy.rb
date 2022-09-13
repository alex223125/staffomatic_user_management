module Services
  module Users
    class Destroy

      include Authenticatable

      ACTION = "Destroy user"

      attr_reader :errors

      def initialize(current_user, target_user)
        @current_user = current_user
        @target_user = target_user
      end

      def call
        if is_current_user?
          raise UserSelfdestructionError
        else
          ActiveRecord::Base.transaction do
            @target_user.destroy!
            Operation.create!(action: ACTION, user: current_user)
          end
        end
      rescue UserSelfdestructionError => e
        Rails.logger.error(e.message)
        @errors = e
      rescue ActiveRecord::ActiveRecordError => e
        Rails.logger.error(e.message)
        @errors = e
      end

    end
  end
end
