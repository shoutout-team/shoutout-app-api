namespace :users do
  # rake users:random_pwds
  task random_pwds: :environment do
    length = 10
    CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + '!@#$%^&*'.split('')

    10.times do
      puts CHARS.sort_by { rand }.join[0...length]
    end
  end
end