require "exception_handling"
require "stringio"
require "json"

class FakeErrorRackApp
  def call(env)
    blow_up! if env["blow_up"] == true

    [200, { "Content-Type" => "text/plain" }, StringIO.new("All good!")]
  end

  private

  def blow_up!
    raise "Bad things happened"
  end
end

RSpec::Matchers.define :an_error_matching do |ex|
  match do |actual|
    actual.class == ex.class && actual.message == ex.message
  end
end

RSpec.describe ExceptionHandling do
  let(:rack_errors) { spy }
  let(:env) { { "blow_up" => true, "rack.errors" => rack_errors } }
  let(:exception) { RuntimeError.new("Bad things happened") }

  subject { described_class.new(FakeErrorRackApp.new) }

  before do
    allow(Raven).to receive(:capture_exception)
  end

  context "when app doesn't error" do
    it "returns apps response" do
      status, headers, body = subject.call({})
      expect(status).to eq(200)
      expect(headers["Content-Type"]).to eq("text/plain")
      expect(body.each.next).to eq("All good!")
    end
  end

  context "when app errors" do
    before do
      allow(ENV).to receive(:[]).with("APP_ENV").and_return("development")
      @resp = subject.call(env)
    end

    it "logs errors to env" do
      expect(rack_errors).to have_received(:puts).twice
      expect(rack_errors).to have_received(:flush).with(no_args).once
    end

    it "returns a 500 rack response" do
      status, headers, body = @resp

      json = JSON.parse(body.each.next)

      expect(status).to eq(500)
      expect(headers["Content-Type"]).to eq("application/json")
      expect(json).to match(
        a_hash_including(
          "error_code" => "internal_error",
          "message" => "Bad things happened"
        )
      )
    end

    it "sends errors to sentry" do
      expect(Raven).to have_received(:capture_exception).with(an_error_matching(exception))
    end
  end

  context "when APP_ENV == 'test'" do
    it "raises errors" do
      expect do
        subject.call(env)
      end.to raise_error(RuntimeError, "Bad things happened")
    end
  end

  context "when APP_ENV == 'production'" do
    it "omits the stack trace" do
      allow(ENV).to receive(:[]).with("APP_ENV").and_return("production")

      status, headers, body = subject.call(env)

      json = JSON.parse(body.each.next)

      expect(status).to eq(500)
      expect(headers["Content-Type"]).to eq("application/json")
      expect(json["message"]).not_to include("Bad things happened")
      expect(json["backtrace"]).to be_nil
    end
  end
end
