# frozen_string_literal: true

require "fileutils"
require "tty-spinner"
require "colorize"

module AIRspecWriter
  class SpecFileHandler
    SPEC_DIRS = {
      "app/models/" => "spec/models",
      "app/controllers/" => "spec/controllers"
    }.freeze

    class << self
      def determine_spec_path(file_path)
        # Ensure we strip out "app/" to avoid double "models/" issue
        relative_path = file_path.sub(%r{^app/}, "")

        # Find matching folder mapping
        spec_dir = SPEC_DIRS.find { |prefix, _| relative_path.start_with?(prefix.sub("app/", "")) }
        spec_folder = spec_dir ? spec_dir[1] : "spec/other"

        # Ensure correct path
        File.join(spec_folder, relative_path.sub(%r{^models/|controllers/}, "").sub(".rb", "_spec.rb"))
      end

      def save_spec_file(file_path, spec_code)
        # Define loading spinner
        spinner = TTY::Spinner.new("[:spinner] RSpec File Create".yellow, format: :dots)

        output_path = determine_spec_path(file_path)

        FileUtils.mkdir_p(File.dirname(output_path))
        File.write(output_path, spec_code)
        # Stop the spinner when AI response is ready
        spinner.success("✅ Done!")
        puts "   - Open the file & review: `code #{output_path}`".light_blue
        puts "   - Run the test: `bundle exec rspec #{output_path}`".light_blue
        puts "   - Refactor if needed & improve test coverage! 🚀\n".green
      end
    end
  end
end
