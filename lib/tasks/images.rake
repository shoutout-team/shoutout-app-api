namespace :images do
  # rake images:test
  task test: :environment do
    user = User.first
    file_path = Rails.root.join('public/data/ruby-logo.png')

    user.avatar.attach(io: File.open(file_path), filename: 'avatar.png')
  end

  # rake images:truncate
  task truncate: :environment do
    raise 'InvalidEnvironent' unless Rails.env.development?

    Rake::Task['images:count'].invoke

    say '>> Performing destroyment of all stored assets'

    Upload.destroy_all
    ActiveStorage::Attachment.destroy_all
    #ActiveStorage::Blob.destroy_all

    Rake::Task['images:count'].reenable
    Rake::Task['images:count'].invoke
  end

  # rake images:count
  task count: :environment do
    say "Uploads: #{Upload.count}"
    say "Attachments: #{ActiveStorage::Attachment.count}"
    say "Blobs: #{ActiveStorage::Blob.count}"
  end
end
