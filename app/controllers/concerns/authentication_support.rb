module AuthenticationSupport
  extend Pundit

  class SignatureNotProvided < StandardError; end

  # A bit of cheating: just return the GID from the signed token to avoid expensive DB access
  def pundit_user
    token = require_token
    user_gid_from_token(token)
  end

  # Generates a per-user uniq token based on :gid and our private :secret_key_base
  # NOTE: SPA has problems with processing "\n" in requests. #84
  # For now we use pipes and convert the token for all inbound and outbound requests. Error from SPA:
  # DOMException: Failed to execute 'setRequestHeader' on 'XMLHttpRequest': 'Token $token
  def generate_token(user)
    return if user.nil?

    signature = signing_key.sign(user.gid)
    signature = Base64.encode64(signature).gsub("\n", '|')
    "#{user.gid}||#{signature}"
  end

  # Verifies the base64-encoded signature (:gid against :signed_token)
  def user_gid_from_token(signed_token)
    user_gid, encoded_signature = signed_token&.split('||')
    # Convert back '|' to required "\n" #84
    encoded_signature.gsub!('|', "\n") if encoded_signature&.ends_with?('|')

    raise SignatureNotProvided if encoded_signature.blank?

    signature = Base64.decode64(encoded_signature)
    verify_key.verify(signature, user_gid)
    user_gid
  rescue Ed25519::VerifyError
    # TODO: Missing error-handling #75
    nil
  rescue SignatureNotProvided
    # TODO: Missing error-handling #75
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
