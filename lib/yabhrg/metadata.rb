require "yabhrg/responses/metadata_tables"
require "yabhrg/responses/metadata_list_update"
require "yabhrg/generators/metadata_list_options"

module Yabhrg
  class Metadata < Client
    def fields(reload = false)
      memoize(reload) do
        JSON.parse(get("meta/fields"))
      end
    end

    def tables(reload = false)
      memoize(reload) do
        xml = get("meta/tables")
        Responses::MetadataTables.parse(xml)
      end
    end

    def lists(reload = false)
      memoize(reload) do
        JSON.parse(get("meta/lists"))
      end
    end

    def list_update(list_id, items = [])
      body = Generators::MetadataListOptions.generate(items)
      xml = put("meta/lists/#{list_id}", body)
      Responses::MetadataListUpdate.parse(xml)
    end

    def time_off_types(reload = false)
      memoize(reload) do
        JSON.parse(get("meta/time_off/types"))
      end
    end

    def time_off_policies(reload = false)
      memoize(reload) do
        JSON.parse(get("meta/time_off/policies"))
      end
    end

    def users(reload = false)
      memoize(reload) do
        JSON.parse(get("meta/users"))
      end
    end
  end
end