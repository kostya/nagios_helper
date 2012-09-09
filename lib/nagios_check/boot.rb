if !defined?(RAILS_ROOT)
  if ENV['BUNDLE_GEMFILE']
    RAILS_ROOT = File.expand_path File.dirname(ENV['BUNDLE_GEMFILE'])
  end
end
