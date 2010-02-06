class DocumentsController < InheritedResources::Base
  respond_to :json, :xml

  def search
    @documents = Document.search(params[:q], :page => params[:page])
    respond_to do |format|
      format.html
      format.json { render :json => Search.new(@documents) }
    end
  end
end