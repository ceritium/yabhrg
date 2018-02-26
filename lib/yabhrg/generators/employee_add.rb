module Yabhrg
  module Generators
    module EmployeeAdd
      class << self
        def generate(attrs = {})
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.employee do
              attrs.each_pair do |key, value|
                xml.field(id: key) do
                  xml.text value
                end
              end
            end
          end

          Nokogiri::XML(builder.to_xml).root.to_xml
        end
      end
    end
  end
end
