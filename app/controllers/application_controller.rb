class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  filter_parameter_logging :password
end