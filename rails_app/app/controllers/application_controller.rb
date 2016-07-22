class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :navigation_items, :mobile_app_request?

  def navigation_items
    [
     { title: "Home Page", path: home_path },
     { title: "Foo Page", path: foo_path },
     { title: "Bar Page", path: bar_path },
    ]
  end

  def mobile_app_request?
    request.env['HTTP_USER_AGENT'].match /(iOSApp|AndroidApp)/
  end
end
