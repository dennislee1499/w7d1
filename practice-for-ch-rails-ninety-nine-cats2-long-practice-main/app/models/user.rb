class User < ApplicationRecord
    validates :username, :session_token, presence:true, uniqueness:true
    validates :password_digest, presence:true
    before_validation :ensure_session_token

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    password_object = BCrypt::Password.new(self.password_digest)
    password_object.is_password?(password)
  end

  def find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user && user.is_password?(password)
      user
    else
      nil
    end
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64 
    self.save!
    self.session_token
  end

  private
  def generate_unique_session_token
    loop do
      session_token = SecureRandom::urlsafe_base64(16)
      return session_token unless User.exists?(session_token: session_token)
    end
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

end
