module ApplicationHelper
  ALERT_TYPES = ["error", "info", "success", "warning"]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = "success" if type == "notice"
      type = "error" if type == "alert"
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                               content_tag(:h4, msg.html_safe), :class => "alert alert-dismissable alert-#{type}")
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def avatar_url(user,options = {})
    options[:size] ||= "48"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=mm"
  end

end
