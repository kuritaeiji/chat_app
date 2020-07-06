module Api::CookiesHelper
  def login(user)
    cookies[:user_id] = { value: user.id, expired: 1.year.from_now }
  end

  def current_user
    if (user_id = cookies[:user_id])
      current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?(user)
    !current_user.nil?
  end
end
