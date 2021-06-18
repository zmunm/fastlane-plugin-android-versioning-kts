# frozen_string_literal: true

require 'fileutils'

module Fastlane
  module Actions
    class GetValueFromBuildAction < Action
      def self.run(params)
        app_project_dir ||= params[:app_project_dir]

        type ||= params[:type]

        case type
        when 'param'
          regex = /
            \s*
            (?<key>#{params[:key]}\s*=\s*)
            (?<left>['"]?)
            (?<value>[a-zA-Z0-9._]*)
            (?<right>['"]?)
            (?<comment>.*)
          /x
        when 'function'
          regex = /
            \s*
            (?<key>#{params[:key]}\s*\(\s*)
            (?<left>['"]?)
            (?<value>[a-zA-Z0-9._]*)
            (?<right>['"]?)
            (?<comment>.*\).*)
          /x
        else
          throw "#{type} is not valid type"
        end

        flavor = params[:flavor]
        flavor_specified = !(flavor.nil? or flavor.empty?)
        regex_flavor = Regexp.new(/[ \t]create\("#{flavor}"\)[ \t]/)
        value = ''
        found = false
        flavor_found = false
        product_flavors_section = false

        Dir.glob("#{app_project_dir}/build.gradle.kts") do |path|
          UI.verbose("path: #{path}")
          UI.verbose("absolute_path: #{File.expand_path(path)}")

          File.open(path, 'r') do |file|
            file.each_line do |line|
              if flavor_specified && !product_flavors_section
                next unless line.include? 'productFlavors'

                product_flavors_section = true
              end

              if flavor_specified && !flavor_found
                next unless line.match(regex_flavor)

                flavor_found = true
              end

              next unless line.match(regex) && !found

              key, left, value, right, comment = line.match(regex).captures
              break
            end
            file.close
          end
        end
        value
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
            key: :type,
            description: 'The property Type ["function", "param"])',
            type: String,
            default_value: 'param'
          )

        ]
      end

      def self.authors
        ['zmunm']
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
