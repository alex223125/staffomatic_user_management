require 'pry'
require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #index' do

    before do
      @archived_users = create_list(:user, 3, is_archived: true)
      @not_archived_users = create_list(:user, 5, is_archived: false)
    end

    context 'with filter params' do

      context "is_archived true" do

        let(:params) { {"filter" => {"is_archived" => "true"}} }

        it 'returns filtered records in correct format' do
          admin_user = double('a user', :logged_in? => true)
          controller.stub(:current_user) { admin_user }

          get :index, params: params, format: :json
          data = JSON.parse(response.body)['data']

          expected_amount = 3
          expect(data.count).to eql(expected_amount)
          expect(data.first).to have_type('user')
          expect(data.first).to have_jsonapi_attributes("email", "is_archived")
        end
      end

      context "is_archived false" do

        let(:params) { {"filter" => {"is_archived" => "false"}} }

        it 'returns filtered records in correct format' do
          admin_user = double('a user', :logged_in? => true)
          controller.stub(:current_user) { admin_user }

          get :index, params: params, format: :json
          data = JSON.parse(response.body)['data']

          expected_amount = 5
          expect(data.count).to eql(expected_amount)
          expect(data.first).to have_type('user')
          expect(data.first).to have_jsonapi_attributes("email", "is_archived")
        end

      end

    end

    context 'without filter params' do

      let(:params) { nil }

      it 'should return all records in correct format' do
        admin_user = double('a user', :logged_in? => true)
        controller.stub(:current_user) { admin_user }

        get :index, params: params, format: :json
        data = JSON.parse(response.body)['data']

        expected_amount = 8
        expect(data.count).to eql(expected_amount)
        expect(data.first).to have_type('user')
        expect(data.first).to have_jsonapi_attributes("email", "is_archived")
      end
    end
  end


  describe 'PUT #update' do

    let(:test_user) { create(:user) }

    context 'when we have correct post request' do

      let(:target_user) { create(:user, email: "test_user_two@test.com", is_archived: nil) }
      let(:attr) { {"email" => "test@test.com", "is_archived" => "false" } }

      it "should update record" do
        admin_user = double(test_user, :logged_in? => true, :email => "test@email.com")
        controller.stub(:current_user) { admin_user }

        put :update, params: {id: target_user.id, user: attr}, format: :json
        data = JSON.parse(response.body)['data']

        expect(data).to have_type('user')
        expect(data).to have_attribute("email").with_value("test@test.com")
        expect(data).to have_attribute("is_archived").with_value(false)
      end
    end

    context 'when we user tries to update himself' do

      let(:attr) { {"email" => "test@test.com", "is_archived" => "false" } }

      it "should return error" do
        controller.stub(:current_user) { test_user }
        put :update, params: {id: test_user.id, user: attr}, format: :json
        errors = JSON.parse(response.body)['errors'].first

        expected_result = {"status"=>nil, "source"=>nil,
                           "title"=>nil, "detail"=>"User can not update himself"}
        expect(errors).to eql(expected_result)
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'when we have correct request' do

      let(:test_user) { create(:user) }
      let(:target_user) { create(:user, email: "test_user_two@test.com", is_archived: nil) }

      it "should destroy record" do
        admin_user = double(test_user, :logged_in? => true, :email => "test@email.com")
        controller.stub(:current_user) { admin_user }

        delete :destroy, params: {id: target_user.id }, format: :json

        result = JSON.parse(response.body)
        expected_result = {}
        expect(result).to eql(expected_result)
      end
    end

    context 'when user tries to delete himself' do

      let(:test_user) { create(:user) }

      it "should return error" do
        controller.stub(:current_user) { test_user }

        delete :destroy, params: {id: test_user.id }, format: :json
        errors = JSON.parse(response.body)['errors'].first

        expected_result = {"status"=>nil, "source"=>nil,
                           "title"=>nil, "detail"=>"User can not destroy himself"}
        expect(errors).to eql(expected_result)
      end
    end
  end
end
