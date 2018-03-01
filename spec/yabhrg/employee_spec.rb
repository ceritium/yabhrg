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

  describe "#changes_since" do
    let(:now) do
      Time.new(2016, 9, 23, 2, 40, 0).utc
    end

    let(:stub_api) do
      stub_request(:get, "#{endpoint}/employees/changed?type=foo&since=#{now.iso8601}").
        to_return(status: 200, body: {}.to_json)
    end

    it "request api" do
      stub_api
      instance.changes_since(type: "foo", since_at: now)

      expect(stub_api).to have_been_requested
    end

    it "parse json" do
      stub_api
      result = instance.changes_since(type: "foo", since_at: now)

      expect(result).to be_a(Hash)
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

      instance.find(42, fields: ["foo", "bar"])

      expect(stub).to have_been_requested.once
    end

    it "parse json" do
      url = "#{endpoint}/employees/42?fields=foo,bar"
      stub_request(:get, url).
        to_return(status: 200, body: { a: :json }.to_json, headers: {})

      result = instance.find(42, fields: ["foo", "bar"])
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

  describe "#report" do
    it "parse json" do
      stub_request(:get, "#{endpoint}/reports/42?fd=yes&format=json").
        to_return(status: 200, body: {}.to_json, headers: {})
      result = instance.report(42)
      expect(result).to be_a(Hash)
    end

    it "fd parameter" do
      stub = stub_request(:get, "#{endpoint}/reports/42?fd=foo&format=json").
             to_return(status: 200, body: {}.to_json, headers: {})

      instance.report(42, fd: "foo")
      expect(stub).to have_been_requested.once
    end
  end

  describe "#raw_report" do
    it "raw response" do
      stub_request(:get, "#{endpoint}/reports/42?fd=yes&format=bar").
        to_return(status: 200, body: "raw body", headers: {})

      result = instance.raw_report(42, format: "bar")
      expect(result).to be_a(Faraday::Response)
    end

    it "fd and format parameters" do
      stub = stub_request(:get, "#{endpoint}/reports/42?fd=foo&format=bar").
             to_return(status: 200, body: "raw body", headers: {})

      instance.raw_report(42, fd: "foo", format: "bar")
      expect(stub).to have_been_requested.once
    end
  end

  describe "#custom_raw_report" do
    it "custom raw response" do
      stub_request(:post, "#{endpoint}/reports/custom?format=bar").
        to_return(status: 200, body: "raw body", headers: {})

      result = instance.custom_raw_report(title: "foo", format: "bar")
      expect(result).to eq("raw body")
    end
  end

  describe "#files" do
    it "request api" do
      stub = stub_request(:get, "#{endpoint}/employees/42/files/view").
             to_return(status: 200, body: "", headers: {})

      instance.files(42)
      expect(stub).to have_been_requested.once
    end
  end

  describe "#add_file_category" do
    it "request api" do
      body = Yabhrg::Generators::AddFileCategory.generate("foo")
      stub = stub_request(:post, "#{endpoint}/employees/files/categories/").
             with(body: body).
             to_return(status: 200, body: "", headers: {})
      instance.add_file_category("foo")
      expect(stub).to have_been_requested.once
    end
  end

  describe "#update_employee_file" do
    it "request api" do
      body = Yabhrg::Generators::EmployeeUpdateFile.generate(foo: :bar)
      stub = stub_request(:post, "#{endpoint}/employees/42/files/24").
             with(body: body).
             to_return(status: 200, body: "", headers: {})
      instance.update_employee_file(42, 24, foo: :bar)
      expect(stub).to have_been_requested.once
    end
  end

  describe "#delete_employee_file" do
    it "request api" do
      stub = stub_request(:delete, "#{endpoint}/employees/42/files/24").
             to_return(status: 200, body: "", headers: {})
      instance.delete_employee_file(42, 24)
      expect(stub).to have_been_requested.once
    end
  end

  describe "#employee_file" do
    let(:stub_api) do
      response_headers = {
        "content-type" => "foo",
        "foo-content-bar" => "bar"
      }

      stub_request(:get, "#{endpoint}/employees/42/files/24").
        to_return(status: 200, body: "body", headers: response_headers)
    end

    it "request api" do
      stub = stub_api

      instance.employee_file(42, 24)
      expect(stub).to have_been_requested.once
    end

    it "return hash" do
      stub_api

      expected_result = {
        body: "body",
        "content-type" => "foo"
      }

      result = instance.employee_file(42, 24)
      expect(result).to eq(expected_result)
    end
  end

  describe "#upload_employee_file" do
    it "request api" do
      attrs = {
        file_path: "spec/support/webmock/metadata_fields.yml",
        category_id: "24",
        file_name: "foo",
        share: "yes"
      }

      stub_request(:post, "#{endpoint}/employees/42/files").
        with(headers: {
               "Accept" => "*/*",
               "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
               "Authorization" => "Basic Zm9vOng=",
               "Content-Length" => "741",
               "Content-Type" => "multipart/form-data; boundary=-----------RubyMultipartPost",
               "User-Agent" => "Yabhrg 0.1.0"
             }).
        to_return(status: 200, body: "", headers: {})

      instance.upload_employee_file(42, attrs)
    end
  end
end
