require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) { create(:user) }

  describe "POST /create" do
    context "valid attributes" do
      it "creates an account" do
        expect {
          post "/users/#{user.id}/accounts", params: { currency: "USD" }
        }.to change(Account, :count).by(1)
      end

      it "deposits into account" do
        post "/users/#{user.id}/accounts/USD/deposit", params: { amount: 150 }
        expect(response).to have_http_status(200)
      end

      it "transfers from one account to another" do
        another_user = create(:user)
        user = create(:user)
        acc = user.accounts.create(currency: "USD")
        acc.balance = 300
        post "/users/#{user.id}/accounts/USD/transfer", params: { amount: 150, recipient_id: another_user.id }
        expect(JSON.parse(response.body)).to eq("transfered" => true)
        expect(response).to have_http_status(200)
      end
    end

    context "invalid attributes" do
      it "doesn't create an account" do
        expect {
          post "/users/#{user.id}/accounts", params: { currency: "invalid currency" }
        }.to change(Account, :count).by(0)
      end

      it "doesnt transfer from non-existent account" do
        another_user = create(:user)
        post "/users/18/accounts/USD/transfer", params: { amount: 150, recipient_id: another_user.id }
        expect(response).to have_http_status(404)
      end
    end
  end
end
