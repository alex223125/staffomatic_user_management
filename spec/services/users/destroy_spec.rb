require 'rails_helper'

RSpec.describe 'Destroy' do

  describe '#call' do

    context 'when we user tries to destroy another user' do

      let(:current_user) { create(:user) }
      let(:target_user) { create(:user, email: "test_user_two@test.com") }

      it 'should destroy target user' do
        service = Services::Users::Destroy.new(current_user, target_user)
        service.call

        users = User.all
        expected_result = 1
        expect(users.count).to eql(expected_result)
      end
    end

    context 'when user tries to destroy himself' do

      let(:current_user) { create(:user) }

      it 'should not destroy target user' do
        target_user = current_user
        service = Services::Users::Destroy.new(current_user, target_user)
        service.call

        users = User.all
        expected_result = 1
        expect(users.count).to eql(expected_result)
      end

      it 'should raise exception' do
        target_user = current_user
        service = Services::Users::Destroy.new(current_user, target_user)
        service.call

        errors = service.errors
        expected_class = UserSelfdestructionError
        expect(errors).to be_instance_of(expected_class)
      end

      it 'should raise exception with correct message' do
        target_user = current_user
        service = Services::Users::Destroy.new(current_user, target_user)

        message = service.errors
        expected_message = 'User can not destroy himself'
        expect(message).to eql(expected_message)
      end

    end
  end
end
