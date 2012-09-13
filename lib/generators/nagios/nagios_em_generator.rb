# for Rails 2.3
if Rails::VERSION::MAJOR == 2

  class NagiosEmGenerator < Rails::Generator::NamedBase
    def manifest
      record do |m|
        m.template "script_class_em.rb", "app/nagios/#{file_path}.rb"
        m.directory "spec/nagios"
        m.template "spec.rb", "spec/nagios/#{file_path}_spec.rb"
      end
    end
  end

end