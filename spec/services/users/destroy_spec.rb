require 'rails_helper'

RSpec.describe 'Destroy' do

  describe '#call' do

    context 'when we user tries to destroy another user' do

      let(:current_user) { create(:user) }
      let(:target_user) { create(:user, email: "test_user_two@test.com") }

      before do
        service = Services::Users::Destroy.new(current_user, target_user)
        service.call
      end

      it 'should destroy target user' do
        users = User.all
        expected_result = 1
        expect(users.count).to eql(expected_result)
      end

      it 'should create one Operation log record' do
        operations = Operation.all

        expected_result = 1
        expected_action = "Destroy user"
        expected_user = current_user.email

        expect(operations.count).to eql(expected_result)
        expect(operations.first.action).to eql(expected_action)
        expect(operations.first.user).to eql(expected_user)
      end
    end

    context 'when user tries to destroy himself' do

      let!(:current_user) { create(:user) }

      before do
        target_user = current_user
        @service = Services::Users::Destroy.new(current_user, target_user)
        @service.call
      end

      it 'should not destroy target user' do
        users = User.all
        expected_result = 1
        expect(users.count).to eql(expected_result)
      end

      it 'should raise exception' do
        errors = @service.errors
        expected_class = UserSelfdestructionError
        expect(errors).to be_instance_of(expected_class)
      end

      it 'should raise exception with correct message' do
        message = @service.errors.message
        expected_message = 'User can not destroy himself'
        expect(message).to eql(expected_message)
      end

    end
  end
end
