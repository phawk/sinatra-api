require "spec_helper"

RSpec.describe UserAuthEmailJob do
  let(:fake_mailer) { double(:fake_mailer) }
  let(:options) { Hash.new }

  context "user signups" do
    it "sends an email" do
      allow(Api::Mailers::User).to receive(:new).and_return(fake_mailer)
      expect(fake_mailer).to receive(:welcome).with(options)
      subject.perform(options.merge(template: "user_signup"))
    end
  end

  context "password resets" do
    it "sends an email" do
      allow(Api::Mailers::User).to receive(:new).and_return(fake_mailer)
      expect(fake_mailer).to receive(:password_reset).with(options)
      subject.perform(options.merge(template: "password_reset"))
    end
  end

  context "password updates" do
    it "sends an email" do
      allow(Api::Mailers::User).to receive(:new).and_return(fake_mailer)
      expect(fake_mailer).to receive(:password_updated).with(options)
      subject.perform(options.merge(template: "password_updated"))
    end
  end
end
