# frozen_string_literal: true

require 'tempfile'
require 'fileutils'

module Fastlane
  module Actions
    module SharedValues
      VERSION_CODE = :VERSION_CODE
    end

    class IncrementVersionCodeAction < Action
      def self.run(params)
        current_version_code = GetVersionCodeAction.run(params)

        new_version_code =
          if params[:version_code].nil?
            current_version_code.to_i + 1
          elsif params[:version_code] == -1
            ((Time.now.to_f * 1000).to_i / (60 * 1000)).to_i
          else
            params[:version_code].to_i
          end

        SetValueInBuildAction.run(
          app_project_dir: params[:app_project_dir],
          flavor: params[:flavor],
          key: 'versionCode',
          value: new_version_code
        )
        Actions.lane_context[SharedValues::VERSION_CODE] = new_version_code.to_s
        new_version_code.to_s
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
            key: :version_code,
            env_name: 'ANDROID_VERSIONING_VERSION_CODE',
            description: 'Change to a specific version (optional)',
            optional: true,
            type: Integer
          )
        ]
      end

      def self.description
        'Increment the version code of your project'
      end

      def self.details
        [
          'This action will increment the version code directly
            in build.gradle.kts'
        ].join("\n")
      end

      def self.output
        [
          ['VERSION_CODE', 'The new version code']
        ]
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
