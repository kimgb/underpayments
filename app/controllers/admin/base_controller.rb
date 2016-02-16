class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authorise_admin!
end
