# frozen_string_literal: true

require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    class SetValueInBuildAction < Action
      def self.run(params)
        app_project_dir ||= params[:app_project_dir]
        regex = /
          (?<key>#{params[:key]}\s*=\s*)
          (?<left>['"]?)
          (?<value>[a-zA-Z0-9._]*)
          (?<right>['"]?)
          (?<comment>.*)
        /x
        flavor = params[:flavor]
        flavor_specified = !(flavor.nil? || flavor.empty?)
        regex_flavor = /[ \t]create\("#{flavor}"\)[ \t]/
        found = false
        product_flavors_section = false
        flavor_found = false
        Dir.glob("#{app_project_dir}/build.gradle.kts") do |path|
          temp_file = Tempfile.new('versioning')
          File.open(path, 'r') do |file|
            file.each_line do |line|
              if flavor_specified && !product_flavors_section
                unless line.include?('productFlavors') || product_flavors_section
                  temp_file.puts line
                  next
                end
                product_flavors_section = true
              end

              if flavor_specified && !flavor_found
                unless line.match(regex_flavor)
                  temp_file.puts line
                  next
                end
                flavor_found = true
              end

              unless line.match(regex) && !found
                temp_file.puts line
                next
              end
              line = line.gsub regex,
                               "\\k<key>\\k<left>#{params[:value]}\\k<right>\\k<comment>"
              found = true
              temp_file.puts line
            end
            file.close
          end
          temp_file.rewind
          temp_file.close

          begin
            FileUtils.mv(temp_file.path, path)
          rescue => ex
            if ex.message.to_s.include? 'Operation not permitted'
              FileUtils.cp(temp_file.path, path)
              FileUtils.rm(temp_file.path)
            else
              raise ex
            end
          end

          temp_file.unlink
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :app_project_dir,
            env_name: 'ANDROID_VERSIONING_APP_PROJECT_DIR',
            description: 'The path to the application source folder
              in the Android project (default: android/app)',
            optional: true,
            type: String,
            default_value: 'android/app'
          ),
          FastlaneCore::ConfigItem.new(
            key: :flavor,
            env_name: 'ANDROID_VERSIONING_FLAVOR',
            description: 'The product flavor name (optional)',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :key,
            description: 'The property key',
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :value,
            description: 'The property value',
            type: String
          )
        ]
      end

      def self.description
        'Set the value of your project'
      end

      def self.details
        [
          'This action will set the value directly in build.gradle.kts '
        ].join("\n")
      end

      def self.authors
        ['Manabu OHTAKE']
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
