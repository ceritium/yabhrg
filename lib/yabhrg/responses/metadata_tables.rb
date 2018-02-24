module Yabhrg
  module Responses
    module MetadataTables
      class << self
        def parse(xml)
          doc = Nokogiri::XML(xml)
          doc.xpath("tables/table").each_with_object({}) do |table, memo|
            memo[table["alias"]] = parse_doc_table_fields(table)
          end
        end

        private

        def parse_doc_table_fields(table)
          table.xpath("field").each_with_object([]) do |field, memo|
            memo << {
              id: field["id"],
              alias: field["alias"],
              type: field["type"],
              value: field.children.to_s
            }
          end
        end
      end
    end
  end
end
