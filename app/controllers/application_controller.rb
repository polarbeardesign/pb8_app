class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def redirect_authenticated_user
    if authenticated
      redirect_to weekly_summary_path
    end
  end
end
