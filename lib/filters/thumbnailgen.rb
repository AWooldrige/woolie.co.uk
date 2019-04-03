module ImageHelper
    def imageVerbatim(itemIdentifier, size=:default)
        item = @items[itemIdentifier]
        img = '<img src="' + item.path(:rep => size) + '" ' \
                   'alt="' + item[:title] + '" ' \
                   'title="' + item[:title] + '" />'
        return img
    end
end

include ImageHelper
