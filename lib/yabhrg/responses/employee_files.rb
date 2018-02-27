module Yabhrg
  module Responses
    module EmployeeFiles
      class << self
        def parse(xml)
          doc = Nokogiri::XML(xml)
          {
            categories: parse_categories(doc.xpath("employee/category"))
          }
        end

        private

        def parse_categories(categories)
          categories.each_with_object([]) do |category, memo|
            memo << {
              id: category["id"],
              name: category.xpath("name").text,
              files: parse_files(category.xpath("file"))
            }
          end
        end

        def parse_files(files)
          files.each_with_object([]) do |file, memo|
            memo << {
              id: file["id"],
              name: file.xpath("name").text,
              original_file_name: file.xpath("originalFileName").text,
              size: file.xpath("size").text,
              date_created: file.xpath("dateCreated").text,
              created_by: file.xpath("createdBy").text,
              share_with_employee: file.xpath("shareWithEmployee").text
            }
          end
        end
      end
    end
  end
end
