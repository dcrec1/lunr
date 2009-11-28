class DocumentsController < InheritedResources::Base
  respond_to :json, :xml

  def search
    render :text => Document.search(params[:q]).to_json
  end
end