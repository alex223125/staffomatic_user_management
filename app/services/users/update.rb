module Services
  module Users
    class Update

      include Authenticatable

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
          @target_user.update!(@params)
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