RSpec.describe Yabhrg::Employee do
  subject(:instance) { described_class.new(api_key: "foo", subdomain: "bar") }

  let(:endpoint) { instance.endpoint }

  describe "#all" do
    let(:stub_api) do
      stub_request(:get, "#{endpoint}/employees/directory").
        to_return(status: 200, body: {}.to_json, headers: {})
    end

    it "parse json" do
      stub_api
      expect(instance.all).to be_a(Hash)
    end
  end

  describe "#find" do
    let(:fields) do
      YAML.load_file("spec/support/webmock/metadata_fields.yml")
    end

    let(:stub_request_fields) do
      url = "#{endpoint}/meta/fields"

      stub_request(:get, url).
        to_return(status: 200, body: fields.to_json, headers: {})
    end

    it "fields :all" do
      stub_request_fields

      url = "#{endpoint}/employees/42?fields=withAlias,anotherWithAlias"
      stub = stub_request(:get, url).
             to_return(status: 200, body: {}.to_json, headers: {})

      instance.find(42)

      expect(stub).to have_been_requested.once
    end

    it "specific fields" do
      url = "#{endpoint}/employees/42?fields=foo,bar"

      stub = stub_request(:get, url).
             to_return(status: 200, body: {}.to_json, headers: {})

      instance.find(42, fields: %w[foo bar])

      expect(stub).to have_been_requested.once
    end

    it "parse json" do
      url = "#{endpoint}/employees/42?fields=foo,bar"
      stub_request(:get, url).
        to_return(status: 200, body: { a: :json }.to_json, headers: {})

      result = instance.find(42, fields: %w[foo bar])
      expect(result).to eq("a" => "json")
    end
  end

  describe "#add" do
    it "post to api" do
      expected_body = <<-XML
<employee>
  <field id="foo">bar</field>
  <field id="bar">foo</field>
</employee>
      XML

      stub = stub_request(:post, "#{endpoint}/employees").
             with(body: expected_body.strip).
             to_return(status: 200, body: "", headers: {})

      instance.add(foo: :bar, bar: :foo)

      expect(stub).to have_been_requested.once
    end
  end

  describe "#update" do
    it "put to api" do
      expected_body = <<-XML
<employee>
  <field id="foo">bar</field>
  <field id="bar">foo</field>
</employee>
      XML

      stub = stub_request(:put, "#{endpoint}/employees/42").
             with(body: expected_body.strip).
             to_return(status: 200, body: "", headers: {})

      instance.update(42, foo: :bar, bar: :foo)

      expect(stub).to have_been_requested.once
    end
  end
end
