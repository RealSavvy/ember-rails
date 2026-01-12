class <%= options[:controller].to_s.camelize %>Controller < ApplicationController
  def <%= options[:action].to_s %>
    # Render the normal Rails layout so the Ember app can boot.
    # This action is intended to be used as a catch-all route target for deep links.
    render :<%= options[:action].to_s %>
  end
end

