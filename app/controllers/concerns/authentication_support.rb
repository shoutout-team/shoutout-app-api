module AuthenticationSupport
  extend Pundit

  # A bit of cheating: just return the GID from the signed token to avoid expensive DB access
  def pundit_user
    token = require_token
    user_gid_from_token(token)
  end

  # Generates a per-user uniq token based on :gid and our private :secret_key_base
  def generate_token(user)
    signature = signing_key.sign(user.gid)
    "#{user.gid}|#{Base64.encode64(signature)}"
  end

  # Verifies the base64-encoded signature (:gid against :signed_token)
  def user_gid_from_token(signed_token)
    user_gid, encoded_signature = signed_token.split('|')
    # Fix escaping done by :token_and_options
    encoded_signature.gsub!("\\n", "\n") if encoded_signature.ends_with?("\\n")

    raise ArgumentError if encoded_signature.blank?

    signature = Base64.decode64(encoded_signature)
    verify_key.verify(signature, user_gid)
    user_gid
  rescue Ed25519::VerifyError
    nil
  end

  private

  def signing_key
    @signing_key = Ed25519::SigningKey.new(Rails.application.credentials.secret_key_base[0, 32])
  end

  def verify_key
    @verify_key = signing_key.verify_key
  end

  def require_token
    # TODO: Remove this option #75
    return params[:token] if params[:token].present?

    # This causes 'ArgumentError - expected 64 byte signature, got 65:' ... but having it in params works! #75
    # OK got it: it escapes "\n" => "\\n" ... whic causes failing base64-decoding
    token, _options = ActionController::HttpAuthentication::Token.token_and_options(request)
    token
  end
end
