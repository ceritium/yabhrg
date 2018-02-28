module Yabhrg
  module Camelize
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
