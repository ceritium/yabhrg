module Yabhrg
  module Responses
    module MetadataListUpdate
      class << self
        def parse(xml)
          doc = Nokogiri::XML(xml)
          lists = doc.xpath("list")
          return false if lists.length.zero?

          list = lists[0]

          {
            list: {
              field_id:     list["fieldId"],
              alias:        list["alias"],
              manageable:   list["manageable"],
              multiple:     list["multiple"],
              name:         list.xpath("name").text,
              options: parse_doc_options(list.xpath("options/option"))
            }
          }
        end

        private

        def parse_doc_options(options = [])
          options.each_with_object([]) do |option, memo|
            memo << {
              id:       option["id"],
              archived:  option["archived"],
              name:     option.text
            }
          end
        end
      end
    end
  end
end
