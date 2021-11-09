require "rails_helper"

RSpec.describe "<%= class_name %> API", type: :request do
  
  before(:all) do   
    @user = FactoryBot.create(:user)
    @<%= singular_table_name %> = FactoryBot.create(:<%= singular_table_name %>)
  end

  let(:headers) { valid_headers }

  describe "GET /api/<%= prefix %>/<%= plural_table_name %>" do
    before { get "/api/<%= prefix %>/<%= plural_table_name %>", params: {}, headers: headers }

    it "returns <%= plural_table_name %>" do
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/<%= prefix %>/<%= plural_table_name %>/:id" do
    before { get "/api/<%= prefix %>/<%= plural_table_name %>/#{@<%= singular_table_name %>.id}", params: {}, headers: headers }

    context "when the record exists" do
      it "returns the <%= singular_table_name %>" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(@<%= singular_table_name %>.id)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the record does not exist" do
      before { get "/api/<%= prefix %>/<%= plural_table_name %>/100", params: {}, headers: headers }

      it "returns status slug code 401" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/<%= prefix %>/<%= plural_table_name %>" do
    let(:invalid_attributes) do
      { 
        attribute: "value",
      }.to_json
    end

    context "when request is valid" do
      before { post "/api/<%= prefix %>/<%= plural_table_name %>/", params: valid_attributes, headers: headers }

      it "creates a <%= singular_table_name %>" do
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

      before { post "/api/<%= prefix %>/<%= plural_table_name %>", params: invalid_attributes, headers: headers }
     
      it "returns status code 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns a validation failure message" do
        expect(json["error"]).not_to be_nil
      end
    end
  end

  describe "PATCH /api/<%= prefix %>/<%= plural_table_name %>/:id" do
    let(:valid_attributes) { { title: "Shopping" }.to_json }

    context "when the record exists" do
      before { patch "/api/<%= prefix %>/<%= plural_table_name %>/#{@<%= singular_table_name %>.id}", params: valid_attributes, headers: headers }

      it "returns a team" do
        expect(json["title"]).to eq("Shopping")
      end

      it "returns status code 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) { { title: "A" }.to_json }

      before { patch "/api/<%= prefix %>/<%= plural_table_name %>/#{@<%= singular_table_name %>.id}", params: invalid_attributes, headers: headers }

      it "returns status code 400" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns a validation failure message" do
        expect(json["error"])
          .to match(["Title is too short (minimum is 2 characters)"])
      end
    end
  end

  describe "DELETE /api/<%= prefix %>/<%= plural_table_name %>/:id" do
    before { delete "/api/<%= prefix %>/<%= plural_table_name %>/#{@<%= singular_table_name %>.id}", params: {}, headers: headers }

    it "returns status code 200" do
      expect(response).to have_http_status(:ok)
    end
  end
end
