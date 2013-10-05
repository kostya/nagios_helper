# for Rails 3
if Rails::VERSION::MAJOR >= 3

  module Nagios
    class CheckGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def add_files
        template "script_class.rb", "app/nagios/#{file_path}.rb"
        template "spec.rb", "spec/nagios/#{file_path}_spec.rb"
      end
    end
  end

end
