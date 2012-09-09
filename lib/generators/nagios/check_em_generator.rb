# for Rails 3
if Rails::VERSION::MAJOR >= 3

  module Nagios
    class CheckEmGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def add_files
        template "script_class_em.rb", "app/nagios/#{file_path}.rb"
        template "spec.rb", "spec/nagios/#{file_path}_spec.rb"
      end
    end    
  end

end

# for Rails 2.3
if Rails::VERSION::MAJOR == 2

  class CheckEmGenerator < Rails::Generator::NamedBase
    def manifest
      record do |m|
        m.template "script_class_em.rb", "app/nagios/#{file_path}.rb"
        m.directory "spec/nagios"
        m.template "spec.rb", "spec/nagios/#{file_path}_spec.rb"
      end
    end
  end

end