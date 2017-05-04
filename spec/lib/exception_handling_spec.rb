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

RSpec.describe ExceptionHandling do
  subject { described_class.new(FakeErrorRackApp.new) }

  context "when app doesn't error" do
    it "returns apps response" do
      status, headers, body = subject.call({})
      expect(status).to eq(200)
      expect(headers["Content-Type"]).to eq("text/plain")
      expect(body.each.next).to eq("All good!")
    end
  end

  context "when app errors" do
    let(:rack_errors) { spy }
    let(:env) { { "blow_up" => true, "rack.errors" => rack_errors } }
    let(:exception) { RuntimeError.new("Bad things happened") }

    before { @resp = subject.call(env) }

    it "logs errors to env" do
      expect(rack_errors).to have_received(:puts).twice
      expect(rack_errors).to have_received(:flush).with(no_args).once
    end

    it "returns a 500 rack response" do
      status, headers, body = @resp

      json = JSON.parse(body.each.next)

      expect(status).to eq(500)
      expect(headers["Content-Type"]).to eq("application/json")
      expect(json).to eq(
        "error_code" => "internal_error",
        "message" => "Internal server error: this is a problem on our end and we've been notified of the issue"
      )
    end

    it "sends errors to sentry"

    context "when developing" do
      it "returns a backtrace"
    end
  end
end
