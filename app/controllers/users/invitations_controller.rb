class Users::InvitationsController < Devise::InvitationsController
  def create
    # Allow inviter to set language of the email.
    inviter_locale = I18n.locale
    email_locale = params.fetch(:user, {})[:locale_for_email] || inviter_locale
    
    I18n.locale = email_locale
    
    
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?
    
    # Restore inviter's locale setting before responding.
    I18n.locale = inviter_locale

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      respond_with resource, :location => after_invite_path_for(current_inviter)
    else
      respond_with_navigational(resource) { render :new }
    end
  end
end
