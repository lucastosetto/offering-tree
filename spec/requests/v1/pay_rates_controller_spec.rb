require 'rails_helper'

RSpec.describe V1::PayRatesController, type: :request do
  describe 'POST /v1/pay_rates' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          rate_name: 'Standard Rate',
          base_rate_per_client: 100.0,
          bonus: {
            rate_per_client: 150.0,
            min_client_count: 5,
            max_client_count: 10
          }
        }
      end

      it 'creates a new pay rate' do
        expect {
          post '/v1/pay_rates', params: valid_params
        }.to change(PayRate, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response['rate_name']).to eq('Standard Rate')
      end
    end
  end

  describe 'PATCH /v1/pay_rates/:id' do
    let(:pay_rate) { create(:pay_rate, rate_name: 'Old Rate') }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          rate_name: 'Updated Rate'
        }
      end

      it 'updates the pay rate' do
        patch "/v1/pay_rates/#{pay_rate.id}", params: valid_params

        expect(response).to have_http_status(:ok)
        expect(json_response['rate_name']).to eq('Updated Rate')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          rate_name: ''
        }
      end

      it 'returns unprocessable entity status' do
        patch "/v1/pay_rates/#{pay_rate.id}", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /v1/pay_rates/:id/payment' do
    let(:pay_rate) { create(:pay_rate) }

    context 'when pay rate exists' do
      it 'calculates payment successfully' do
        get "/v1/pay_rates/#{pay_rate.id}/payment", params: { client_count: 10 }

        expect(response).to have_http_status(:ok)
        expect(json_response).to include('payment')
        expect(json_response['payment']).to include('amount')
      end
    end

    context 'when pay rate does not exist' do
      it 'returns not found status' do
        get "/v1/pay_rates/0/payment", params: { client_count: 10 }

        expect(response).to have_http_status(:not_found)
        expect(json_response).to include('error')
      end
    end
  end
end