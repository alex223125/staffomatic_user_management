require 'rails_helper'

RSpec.describe 'Update' do

  describe '#call' do

    context 'when user updates another user' do

      let(:current_user) { create(:user) }
      let(:target_user) { create(:user, email: "test_user_two@test.com", is_archived: nil) }

      before do
        service = Services::Users::Update.new(current_user, target_user,
                                              params)
        service.call
      end

      context 'when we change status to true' do

        let(:params) { {is_archived: true} }

        it 'should change archived status to true' do
          expected_result = true
          expect(target_user.is_archived).to eql(expected_result)
        end

        it 'should create one Operation log record' do
          operations = Operation.all

          expected_result = 1
          expected_action = "Update existing user"
          expected_user = current_user.email

          expect(operations.count).to eql(expected_result)
          expect(operations.first.action).to eql(expected_action)
          expect(operations.first.user).to eql(expected_user)
        end
      end

      context 'when we change status to false' do

        let(:params) { {is_archived: false} }

        it 'should change archived status to true' do
          expected_result = false
          expect(target_user.is_archived).to eql(expected_result)
        end
      end
    end

    context 'when user tries to update himself' do

      let(:current_user) { create(:user) }
      let(:params) { {is_archived: true} }

      before do
        target_user = current_user
        @service = Services::Users::Update.new(current_user, target_user,
                                              params)
        @service.call
      end

      it 'should raise exception' do
        errors = @service.errors
        expected_class = UserUpdatesHimselfError
        expect(errors).to be_instance_of(expected_class)
      end

      it 'should raise exception with correct message' do
        message = @service.errors.message
        expected_message = 'User can not update himself'
        expect(message).to eql(expected_message)
      end

    end
  end
end
