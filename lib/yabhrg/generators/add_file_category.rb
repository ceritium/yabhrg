module Yabhrg
  module Generators
    module AddFileCategory
      class << self
        def generate(category_name)
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.employee do
              xml.category category_name
            end
          end

          Nokogiri::XML(builder.to_xml).root.to_xml
        end
      end
    end
  end
end
