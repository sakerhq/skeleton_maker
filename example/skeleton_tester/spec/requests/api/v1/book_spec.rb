require "rails_helper"

RSpec.describe "Book API", type: :request do
  
  before(:all) do   
    @user = FactoryBot.create(:user)
    @book = FactoryBot.create(:book)
  end

  let(:headers) { valid_headers }

  describe "GET /api/v1/books" do
    before { get "/api/v1/books", params: {}, headers: headers }

    it "returns books" do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/books/:id" do
    before { get "/api/v1/books/#{@book.id}", params: {}, headers: headers }

    context "when the record exists" do
      it "returns the book" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(@book.id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record does not exist" do
      before { get "/api/v1/books/100", params: {}, headers: headers }

      it "returns status slug code 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/books" do
    let(:invalid_attributes) do
      { 
        attribute: "value",
      }.to_json
    end

    context "when request is valid" do
      before { post "/api/v1/books/", params: valid_attributes, headers: headers }

      it "creates a book" do
        expect(json["title"]).to eq("Tennis lesson")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) do
        { 
          attribute: "value",
        }.to_json
      end

      before { post "/api/v1/books", params: invalid_attributes, headers: headers }
     
      it "returns status code 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns a validation failure message" do
        expect(json["error"]).not_to be_nil
      end
    end
  end

  describe "PATCH /api/v1/books/:id" do
    let(:valid_attributes) { { title: "Shopping" }.to_json }

    context "when the record exists" do
      before { patch "/api/v1/books/#{@book.id}", params: valid_attributes, headers: headers }

      it "returns a team" do
        expect(json["title"]).to eq("Shopping")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) { { title: "A" }.to_json }

      before { patch "/api/v1/books/#{@book.id}", params: invalid_attributes, headers: headers }

      it "returns status code 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns a validation failure message" do
        expect(json["error"])
          .to match(["Title is too short (minimum is 2 characters)"])
      end
    end
  end

  describe "DELETE /api/v1/books/:id" do
    before { delete "/api/v1/books/#{@book.id}", params: {}, headers: headers }

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end
end
