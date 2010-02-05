require 'spec_helper'

describe DocumentsController do
  should_behave_like_resource :formats => [:html, :json, :xml]

  context "responding to GET search" do
    before :each do
      @query = "blue"
      @documents = [Document.new]
      @documents.stub!(:suggest).and_return(@suggest = "ruby for dummies")
      Document.stub!(:search).with(@query).and_return(@documents)
    end
    
    context "with json format" do
      it "should return found documents" do
        get :search, :format => 'json', :q => @query
        ActiveSupport::JSON.decode(response.body)['documents'].to_json.should eql(@documents.to_json)
      end

      it "should render a suggestion" do
        get :search, :format => 'json', :q => @query
        ActiveSupport::JSON.decode(response.body)['suggest'].should eql(@suggest)
      end
    end
   end
end