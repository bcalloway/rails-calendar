Factory.define :user do |f|
  f.sequence(:login){ |n| "user_#{n}" }
  f.sequence(:email){ |n| "user_#{n}@scullytown.com" }
  f.password              '123456'
  f.password_confirmation '123456'
  f.password_salt         salt = Authlogic::Random.hex_token
  f.crypted_password      Authlogic::CryptoProviders::Sha512.encrypt("123456" + salt)
  f.perishable_token      Authlogic::Random.friendly_token
  f.association           :role_id, :factory => :role
end

Factory.define :role do |f|
  f.name    'admin'
end

Factory.define :comatose_page do |f|
  f.parent_id         1
  f.full_path         'contact-us'
  f.title             'Contact Us'
  f.slug              'contact-us'
  f.keywords          'blah-blah'
  f.body              'Lorem ipsum dolor sit amet, consectetur adipisicing'
  f.version           2
  #f.role_id           1
  #f.state             'approved'
  f.created_on        Time.now
  f.updated_on        Time.now
  f.association       :role_id, :factory => :role
end

Factory.define :calendar do |f|
  f.event         'Home Game'
  f.description   'Game against the West Side for state championship'
  f.start_date    Time.now
  f.end_date      Time.now
  f.association   :program_id, :factory => :program
end

Factory.define :program do |f|
  f.name            'Recreational'
  f.created_at      Time.now
  f.updated_at      Time.now
end
