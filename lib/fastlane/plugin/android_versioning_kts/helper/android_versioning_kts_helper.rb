require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class AndroidVersioningKtsHelper
      # class methods that you define here become available in your action
      # as `Helper::AndroidVersioningKtsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the android_versioning_kts plugin helper!")
      end
    end
  end
end
