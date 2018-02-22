require "nokogiri"

module Yabhrg
  module Responses
    module MetadataTables
      class << self
        def parse(xml)
          doc = Nokogiri::Slop(xml)
          doc.tables.table.each_with_object({}) do |table, memo|
            memo[table["alias"]] = parse_doc_table_fields(table)
          end
        end

        def parse_doc_table_fields(table)
          table.field.each_with_object([]) do |field, memo|
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
