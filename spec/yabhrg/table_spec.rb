RSpec.describe Yabhrg::Table do
  subject(:instance) { described_class.new(api_key: "foo", subdomain: "bar") }

  let(:endpoint) { instance.endpoint }

  describe "#rows" do
    let(:stub_api) do
      stub_request(:get, "#{endpoint}/employees/42/tables/foobar").
        to_return(status: 200, body: "")
    end

    it "request api" do
      stub = stub_api

      instance.rows(42, "foobar")
      expect(stub).to have_been_requested
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
end
