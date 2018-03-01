RSpec.describe Yabhrg::Table do
  subject(:instance) { described_class.new(api_key: "foo", subdomain: "bar") }

  let(:endpoint) { instance.endpoint }

  describe "#rows" do
    let(:stub_api) do
      stub_request(:get, "#{endpoint}/employees/42/tables/foobar").
        to_return(status: 200, body: [].to_json)
    end

    it "request api" do
      stub = stub_api

      instance.rows(42, "foobar")
      expect(stub).to have_been_requested
    end

    it "parse json" do
      stub_api
      result = instance.rows(42, "foobar")
      expect(result).to be_a(Array)
    end
  end

  describe "#update_row" do
    let(:stub_api) do
      body = Yabhrg::Generators::RowFields.generate(foo: :bar)
      stub_request(:post, "#{endpoint}/employees/42/tables/foobar/24").
        with(body: body).to_return(status: 200, body: "")
    end

    it "request api" do
      stub = stub_api

      instance.update_row(42, "foobar", 24, foo: :bar)
      expect(stub).to have_been_requested
    end
  end

  describe "#add_row" do
    let(:stub_api) do
      body = Yabhrg::Generators::RowFields.generate(foo: :bar)
      stub_request(:post, "#{endpoint}/employees/42/tables/foobar").
        with(body: body).to_return(status: 200, body: "")
    end

    it "request api" do
      stub = stub_api

      instance.add_row(42, "foobar", foo: :bar)
      expect(stub).to have_been_requested
    end
  end

  describe "#changes_since" do
    let(:now) do
      Time.new(2016, 9, 23, 0o2, 40, 0).utc
    end

    let(:stub_api) do
      xml = File.read("spec/support/webmock/table_changes.xml")
      stub_request(:get, "#{endpoint}/employees/changed/tables/foobar?since=#{now.iso8601}").
        to_return(status: 200, body: xml)
    end

    it "request api passing a string" do
      stub = stub_api

      instance.changes_since("foobar", now.to_s)
      expect(stub).to have_been_requested
    end

    it "request api passing a Time" do
      stub = stub_api

      instance.changes_since("foobar", now)
      expect(stub).to have_been_requested
    end
  end
end
