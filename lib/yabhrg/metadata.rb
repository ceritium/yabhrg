require "yabhrg/responses/metadata_tables"

module Yabhrg
  class Metadata < Client
    def fields(reload = false)
      @fields = JSON.parse(get("meta/fields")) if @fields.nil? || reload

      @fields
    end

    def tables
      xml = get("meta/tables")
      Responses::MetadataTables.parse(xml)
    end
  end
end
