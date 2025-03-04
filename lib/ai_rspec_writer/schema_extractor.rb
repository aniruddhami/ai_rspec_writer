# frozen_string_literal: true

require "active_support/core_ext/string" # ✅ Fix: Ensure String#camelize, #underscore, etc., are available
require "tty-spinner"
require "colorize"

module AIRspecWriter
  class SchemaExtractor
    SCHEMA_FILE = "db/schema.rb"

    def self.extract_schema_from_file(table_names)
      return nil unless table_names

      # Define loading spinner
      spinner = TTY::Spinner.new("[:spinner] Fetching Schema From Schema.rb : ".yellow, format: :dots)

      # Start the spinner
      spinner.auto_spin
      extract_schema(table_names, spinner)
    end

    def self.extract_schema(table_names, spinner)
      unless File.exist?(SCHEMA_FILE)
        spinner.error("\n❌ Error: `db/schema.rb` not found. Run `rails db:migrate` first.")
        return nil
      end
      
      schema_content = File.read(SCHEMA_FILE)
      
      match = "" # ✅ Fix: Initialize match variable to avoid nil error
      matched_tables = []
      table_names.map do |table_name|
        matched_data = schema_content.match(/create_table "#{table_name}".*?^\s*end$/m)
        if matched_data.present?
          match += "#{matched_data[0]}\n\n" 
          matched_tables << table_name
        end
      end.join("\n\n") # Combine multiple files
      
      if match
        # Stop the spinner when AI response is ready
        spinner.success("#{matched_tables} ✅ Done!")
        return match
      else
        spinner.error("(No schema found for table: #{table_names})")
        return nil
      end
    end
  end
end
