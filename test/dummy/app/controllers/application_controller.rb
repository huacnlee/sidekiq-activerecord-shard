class ApplicationController < ActionController::Base
  before_action :set_current_tenant_id

  def set_current_tenant_id
    Current.tenant_id = request.headers["x-tenant-id"] || cookies["x-tenant-id"]
  end
end
