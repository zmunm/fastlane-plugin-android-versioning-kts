describe Fastlane::Actions::AndroidVersioningKtsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The android_versioning_kts plugin is working!")

      Fastlane::Actions::AndroidVersioningKtsAction.run(nil)
    end
  end
end
