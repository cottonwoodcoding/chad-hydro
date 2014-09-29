module ApplicationHelper
  def flash_class(level)
    case level
      when :notice then
        'info'
      when :error then
        'error'
      when :alert then
        'warning'
    end
  end

  def admin?
    user_signed_in? && current_user.role == 'admin' || user_signed_in? && current_user.role == 'super admin'
  end
end
