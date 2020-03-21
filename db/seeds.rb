unless User.any?
  User.create(email: 'michael.ajwani@i22.de', name: 'Micha', password: 'Development123!', role: :developer, approved: true)
  User.create(email: 'leo.reuter@i22.de', name: 'Leo', password: 'Development123!', role: :developer, approved: true)
  User.create(email: 'henry.steinhauer@i22.de', name: 'Henry', password: 'Development123!', role: :developer, approved: true)
  User.create(email: 'dominik.criado@i22.de', name: 'Dominik', password: 'Development123!', role: :administrator, approved: true)
  User.create(email: 'lena.overkamp@i22.de', name: 'Lena', password: 'Development123!', role: :administrator, approved: true)
  User.create(email: 'jessica.willius@i22.de', name: 'Jessi', password: 'Development123!', role: :administrator, approved: true)
end
