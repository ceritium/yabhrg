module Yabhrg
  module Generators
    module MetadataListOptions
      class << self
        def generate(items = [])
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.options do
              items.each do |item|
                if item.is_a?(Hash)
                  xml.option(id: item[:id], archived: item[:archived]) do
                    xml.text item[:value]
                  end
                else
                  xml.option item
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
