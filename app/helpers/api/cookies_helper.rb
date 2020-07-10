module Api::CookiesHelper
  def login(user)
    cookies[:user_id] = { value: user.id, expired: 1.year.from_now }
  end

  def current_user
    if cookies[:user_id]
      current_user ||= User.find_by(id: cookies[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end
end
