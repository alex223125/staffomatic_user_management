module Services
  module Users
    class Index

      attr_reader :users

      def initialize(filter_params)
        @filter_params = filter_params
      end

      def call
        @users = User.all
        filter_by_archived if @filter_params.try(:[], "is_archived")
      end

      private

      def filter_by_archived
        @users = @users.where(is_archived: @filter_params["is_archived"])
      end
    end
  end
end