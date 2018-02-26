module Yabhrg
  module Generators
    module CustomReport
      class << self
        def generate(title:, fields: [], filters: {})
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.report do
              xml.title title
              xml.filters do |node|
                filters.each_pair do |key, attrs|
                  value = attrs.delete(:value)
                  attrs = attrs.each_with_object({}) do |attr, memo|
                    memo[camelize(attr[0])] = attr[1]
                  end

                  node.send(camelize(key), attrs) do
                    xml.text value
                  end
                end
              end
              xml.fields do
                fields.each do |field|
                  xml.field(id: field)
                end
              end
            end
          end

          Nokogiri::XML(builder.to_xml).root.to_xml
        end

        def camelize(string, uppercase_first_letter = false)
          string = string.to_s

          string = if uppercase_first_letter
                     string.sub(/^[a-z\d]*/) { $&.capitalize }
                   else
                     string.sub(/^(?:(?=\b|[A-Z_])|\w)/) { $&.downcase }
                   end
          string.
            gsub(%r{(?:_|(\/))([a-z\d]*)}) do
              "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
            end.gsub("/", "::")
        end
      end
    end
  end
end
