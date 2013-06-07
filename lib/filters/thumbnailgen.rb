module ImageHelper
    def imageVerbatim(itemIdentifier, size=:default)
        item = @items[itemIdentifier]
        img = '<img src="' + item.path(:rep => size) + '" ' \
                   'alt="' + item[:title] + '" ' \
                   'title="' + item[:title] + '">'
    end
end

include ImageHelper
