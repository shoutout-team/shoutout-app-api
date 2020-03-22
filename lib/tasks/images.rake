# rake images:test
namespace :images do
  task test: :environment do
    user = User.first
    file_path = Rails.root.join('public/data/ruby-logo.png')

    user.image.attach(io: File.open(file_path), filename: 'avatar.png')
  end
end
