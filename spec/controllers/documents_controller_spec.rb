require 'spec_helper'

describe DocumentsController do
  should_behave_like_resource :formats => [:html, :json, :xml]

  context "responding to GET search" do
    before :each do
      @query = "blue"
      @documents = [Document.new]
      Document.stub!(:search).with(@query).and_return(@documents)
    end

    it "should render searched documents as JSON" do
      get :search, :format => 'json', :q => @query
      response.body.should eql(@documents.to_json)
    end
  end
end
