RSpec.describe Yabhrg::Metadata do
  subject(:instance) { described_class.new(api_key: "foo", subdomain: "bar") }

  let(:fields_response) do
    YAML.load_file("spec/support/webmock/metadata_fields.yml")
  end

  let(:tables_response) do
    File.read("spec/support/webmock/metadata_tables.xml")
  end

  let(:lists_response) do
    File.read("spec/support/webmock/metadata_lists.json")
  end

  def stub_request_fields
    url = "https://api.bamboohr.com/api/gateway.php/bar/v1/meta/fields"

    stub_request(:get, url).
      to_return(status: 200, body: fields_response.to_json, headers: {})
  end

  def stub_request_tables
    url = "https://api.bamboohr.com/api/gateway.php/bar/v1/meta/tables"

    stub_request(:get, url).
      to_return(status: 200, body: tables_response, headers: {})
  end

  def stub_request_lists
    url = "https://api.bamboohr.com/api/gateway.php/bar/v1/meta/lists"

    stub_request(:get, url).
      to_return(status: 200, body: lists_response, headers: {})
  end

  describe "#fields" do
    it "parse json" do
      stub_request_fields
      expect(instance.fields).to eq(fields_response)
    end

    it "memoize request" do
      stub = stub_request_fields

      instance.fields
      instance.fields
      expect(stub).to have_been_requested.once
    end

    it "force request" do
      stub = stub_request_fields

      instance.fields
      instance.fields(true)
      expect(stub).to have_been_requested.twice
    end
  end

  describe "#tables" do
    it "parse xml" do
      stub_request_tables
      tables = instance.tables

      expected_response = {
        "tableOne" =>
          [
            { id: "1", alias: "fieldTypeDate", type: "date", value: "Field Type Date" },
            { id: "2", alias: "otherField1", type: "list", value: " other field 1" }
          ],
        "tableTwo" =>
          [
            { id: "3", alias: "otherField2", type: "date", value: "other field 2" },
            { id: "4", alias: "otherField3", type: "list", value: "other field 3" }
          ]
      }

      expect(tables).to eq(expected_response)
    end

    it "memoize request" do
      stub = stub_request_tables

      instance.tables
      instance.tables
      expect(stub).to have_been_requested.once
    end

    it "force request" do
      stub = stub_request_tables

      instance.tables
      instance.tables(true)
      expect(stub).to have_been_requested.twice
    end
  end

  describe "#lists" do
    it "parse json" do
      stub_request_lists
      expect(instance.lists.to_json).to eq(JSON.parse(lists_response).to_json)
    end

    it "memoize request" do
      stub = stub_request_lists

      instance.lists
      instance.lists
      expect(stub).to have_been_requested.once
    end

    it "force request" do
      stub = stub_request_lists

      instance.lists
      instance.lists(true)
      expect(stub).to have_been_requested.twice
    end
  end

  describe "#list_update" do
    it "do proper request" do
      url = "https://api.bamboohr.com/api/gateway.php/bar/v1/meta/lists/42"
      stub = stub_request(:put, url).
             with(body: "<options>\n  <option>foo</option>\n</options>").
             to_return(status: 200, body: "", headers: {})

      instance.list_update(42, ["foo"])
      expect(stub).to have_been_requested.once
    end

    it "handle success response" do
      response_body = <<-XML
<list fieldId="42" alias="department" manageable="yes" multiple="no">
<name>Department</name>
<options>
  <option id="11422" archived="no">foo</option>
</options>
</list>
      XML

      url = "https://api.bamboohr.com/api/gateway.php/bar/v1/meta/lists/42"
      stub_request(:put, url).
        with(body: "<options>\n  <option>foo</option>\n</options>").
        to_return(status: 200, body: response_body, headers: {})

      response = instance.list_update(42, ["foo"])

      expected_response = {
        list: {
          field_id: "42",
          alias: "department",
          manageable: "yes",
          multiple: "no",
          name: "Department",
          options: [
            {
              id: "11422", archived: "no", name: "foo"
            }
          ]
        }
      }
      expect(response).to eq(expected_response)
    end
  end
end
