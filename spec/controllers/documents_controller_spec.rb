require 'spec_helper'

describe DocumentsController do
  should_behave_like_resource :formats => [:html, :json, :xml], :paginate => true

  context "responding to GET search" do
    before :each do
      @query = "blue"
      @documents = [Document.new]
      @documents.stub!(:suggest).and_return(@suggest = "ruby for dummies")
      Document.stub!(:search).and_return(@documents)
    end
    
    it "should search documents by the parameter q" do
      Document.should_receive(:search).with(@query, anything).and_return(@documents)
      get :search, :format => 'html', :q => @query
    end
    
    it "should paginate documents by the parameter page" do
      Document.should_receive(:search).with(anything, :page => '5').and_return(@documents)
      get :search, :format => 'html', :q => @query, :page => '5'
    end
    
    context "with html format" do
      it "renders the search template" do
        get :search, :format => 'html', :q => @query
        response.should render_template("search")
      end
      
      it "assigns the documents founds as @documents" do
        get :search, :format => 'html', :q => @query
        assigns[:documents].should eql(@documents)
      end
    end
    
    context "with json format" do
      it "should return found documents" do
        get :search, :format => 'json', :q => @query
        Crack::JSON.parse(response.body)['documents'].to_json.should eql(@documents.to_json)
      end

      it "should render a suggestion" do
        get :search, :format => 'json', :q => @query
        Crack::JSON.parse(response.body)['suggest'].should eql(@suggest)
      end
    end
  end
end