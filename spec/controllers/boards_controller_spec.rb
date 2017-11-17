require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe BoardsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Board. As you add validations to Board, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      :height      => Random.rand(10...100),
      :width       => Random.rand(10...100),
      :bombs_count => Random.rand(1...100)
    }
  }

  let(:invalid_attributes) {
    {}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # BoardsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST #create" do
     context "with valid params" do
       it "creates a new Board" do
         post :create, params: {board: valid_attributes}, as: :json, session: valid_session
         expect(Board.count).to eq(1)
       end

       it "renders a JSON response with the new board" do

         post :create, params: {board: valid_attributes}, session: valid_session
         expect(response).to have_http_status(:created)
         expect(response.content_type).to eq('application/json')
       end
     
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new board" do

        post :create, params: {board: invalid_attributes}, as: :json,  session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested board" do
      board = Board.create! valid_attributes
      expect {
        delete :destroy, params: {id: board.to_param}, session: valid_session
      }.to change(Board, :count).by(-1)
    end
  end
  
  describe "GET #playing" do
    before(:each) do
      post :create, params: {board: valid_attributes}, session: valid_session
    end

    it "returns if the game is on" do
      get :playing
      expect(response.content_type).to eq('application/json')
      expect(response).to have_http_status(:ok)
      expect([true, false]).to include(JSON.parse(response.body)["playing"])
    end
  end

  describe "PATCH #flag" do
    before :each do
      post :create, params: {board: valid_attributes}, session: valid_session
      @line = Random.rand(0...valid_attributes[:height].to_i)
      @column = Random.rand(0...valid_attributes[:width].to_i)
    end

    it "return a JSON response with the flagged board" do
      patch :flag, params: {"line": @line, "column": @column}, as: :json, session: valid_session
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "changes the flag attribute on the passed cell" do
      patch :flag, params: {"line": @line, "column": @column}, as: :json, session: valid_session
      expect(Board.first.lines[@line].cells[@column].flag).to be_truthy
    end
  end

  describe "PATCH #play" do
    before :each do
      post :create, params: {board: valid_attributes}, session: valid_session
      @line = Random.rand(0...valid_attributes[:height])
      @column = Random.rand(0...valid_attributes[:width])
    end

    it "return a JSON response with the discovered board" do
      patch :flag, params: {"line": @line, "column": @column}, as: :json, session: valid_session
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json')
    end

    it "discover at least the played cell" do
      patch :play, params: {"line": @line, "column": @column}, as: :json, session: valid_session
      expect(Board.first.lines[@line].cells[@column].discovered).to be_truthy
    end
  end
end
