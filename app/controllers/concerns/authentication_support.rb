module AuthenticationSupport
  extend Pundit

  # A bit of cheating: just return the GID from the signed token to avoid expensive DB access
  def pundit_user
    token, _options = token_and_options(request)
    user_gid_from_token(token)
  end

  def generate_token(user)
    signature = signing_key.sign(user.gid)
    "#{user.gid}|#{Base64.encode64(signature)}"
  end

  def user_gid_from_token(signed_token)
    user_gid, encoded_signature = signed_token.split('|')
    raise ArgumentError if encoded_signature.blank?

    signature = Base64.decode64(encoded_signature)
    verify_key.verify(signature, user_gid)
    user_gid
  rescue Ed25519::VerifyError
    nil
  end

  private

  def signing_key
    @signing_key = Ed25519::SigningKey.new(Rails.application.secrets.secret_key_base[0, 32])
  end

  def verify_key
    @verify_key = signing_key.verify_key
  end
end
