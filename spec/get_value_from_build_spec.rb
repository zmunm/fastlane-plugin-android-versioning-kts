require 'spec_helper'

describe Fastlane::Actions::GetValueFromBuildAction do
  describe "Get compileSdkVersion" do
    def execute_lane_test
      Fastlane::FastFile.new.parse("lane :test do
        get_value_from_build(
          app_project_dir: \"../**/app\",
          key: \"compileSdkVersion\",
          type: \"function\"
        )
      end").runner.execute(:test)
    end

    it "should return compileSdkVersion from build.gradle.kts" do
      result = execute_lane_test
      expect(result).to eq("28")
    end
  end
end
