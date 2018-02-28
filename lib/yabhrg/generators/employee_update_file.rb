require "yabhrg/camelize"

module Yabhrg
  module Generators
    module EmployeeUpdateFile
      class << self
        include Camelize

        def generate(attrs = {})
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.file do |node|
              attrs.each_pair do |key, value|
                node.send(camelize(key)) do
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
