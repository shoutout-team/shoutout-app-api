namespace :app do
  namespace :mail do
    # rake app:mail:test
    task test: :environment do
      mailer = ActionMailer::Base.new

      # check settings:
      mailer.delivery_method # -> :smtp
      mailer.smtp_settings # -> { address: "localhost", port: 25, domain: "localhost.localdomain", user_name: nil, password: nil, authentication: nil, enable_starttls_auto: true }

      # send mail:
      sender = Rails.application.credentials.dig(:mails, :info)
      receiver = Rails.application.credentials.dig(:mails, :devop)

      mailer.mail(from: sender, to: receiver, subject: 'test', body: "Hello, you've got mail!").deliver
    end
  end
end
