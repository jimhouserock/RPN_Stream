require 'rails_helper'

# Controller tests for RPN Calculator web interface
# Author: Jimmy Lin
RSpec.describe RpnController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns empty values for initial load' do
      get :index
      expect(assigns(:result)).to be_nil
      expect(assigns(:expression)).to eq("")
      expect(assigns(:error)).to be_nil
    end
  end

  describe 'POST #calculate' do
    context 'with valid expression' do
      it 'calculates the result correctly' do
        post :calculate, params: { expression: '10 3 +' }
        expect(assigns(:result)).to eq(13)
        expect(assigns(:expression)).to eq('10 3 +')
        expect(assigns(:error)).to be_nil
        expect(response).to render_template(:index)
      end

      it 'handles complex expressions' do
        post :calculate, params: { expression: '10 3 2 + -' }
        expect(assigns(:result)).to eq(5)
        expect(assigns(:error)).to be_nil
      end
    end    context 'with invalid expression' do
      it 'handles RPN errors gracefully' do
        post :calculate, params: { expression: '5 0 /' }
        expect(assigns(:result)).to be_nil
        expect(assigns(:error)).to eq('Division by zero')
        expect(assigns(:expression)).to eq('5 0 /')
        expect(response).to render_template(:index)
      end

      it 'handles insufficient operands' do
        post :calculate, params: { expression: '5 +' }
        expect(assigns(:result)).to be_nil
        expect(assigns(:error)).to eq("Insufficient operands for operator '+'")
      end

      it 'handles invalid tokens' do
        post :calculate, params: { expression: '5 a +' }
        expect(assigns(:result)).to be_nil
        expect(assigns(:error)).to eq("Invalid token: 'a'")
      end
    end

    context 'with empty or missing expression' do
      it 'handles empty expression' do
        post :calculate, params: { expression: '' }
        expect(assigns(:result)).to eq(0)
        expect(assigns(:error)).to be_nil
      end

      it 'handles missing expression parameter' do
        post :calculate
        expect(assigns(:result)).to eq(0)
        expect(assigns(:error)).to be_nil
      end
    end
  end
end