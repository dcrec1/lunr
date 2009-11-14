require 'spec_helper'

describe DocumentsController do
  should_behave_like_resource :formats => [:html, :json, :xml]
end
