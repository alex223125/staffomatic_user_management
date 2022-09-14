require 'rails_helper'

RSpec.describe 'Update' do

  describe '#call' do

    context 'when user tries to get records' do

      let!(:archived_users) { create_list(:user, 3, is_archived: true) }
      let!(:not_archived_users) { create_list(:user, 5, is_archived: false) }

      before do
        @service = Services::Users::Index.new(params)
        @service.call
      end

      context "archived users" do

        let(:params) { {"is_archived" => "true"} }

        it 'should return archived users' do
          result = @service.users.count
          expected_result = 3
          expect(result).to eql(expected_result)
        end

      end

      context "not archived users" do

        let(:params) { {"is_archived" => "false"} }

        it 'should return not archived users' do
          result = @service.users.count
          expected_result = 5
          expect(result).to eql(expected_result)
        end

      end
    end
  end
end
