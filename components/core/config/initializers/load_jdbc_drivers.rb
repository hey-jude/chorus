# KT TODO: think some more about the lib/libraries JARs
Dir[Rails.root.join('lib', 'libraries', '*.jar')].each do |filename|
  require filename
end