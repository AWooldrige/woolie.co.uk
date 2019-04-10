class Thumbnails < Nanoc::Filter

    identifier :thumbnails
    type       :binary

    def run(filename, params={})
        system(
            'gm',
            'convert',
            '+profile', '"*"',
            '-quality', '82',
            '-thumbnail', params[:width].to_s,
            '-type', 'TrueColor',
            '-interlace', 'None',
            filename,
            output_filename)
    end
end

module ImageHelper

    def imageThumbnail(itemIdentifier, size=:small)
        item = @items[itemIdentifier]
        img = '<img src="' + item.path(:rep => size) + '" ' \
                   'title="' + item[:title] + '" ' \
                   'class="img-thumbnail" ' \
                   'title="' + item[:title] + '">'
        '<a href="' + item.path + '">' + img + '</a>'
    end

    def image(itemIdentifier, size=:small)
        item = @items[itemIdentifier]
        img = '<img src="' + item.path(:rep => size) + '" ' \
                   'title="' + item[:title] + '" ' \
                   'class="img-fluid" ' \
                   'title="' + item[:title] + '">'
        return img
    end

    def imageVerbatim(itemIdentifier, size=:default)
        item = @items[itemIdentifier]
        img = '<img src="' + item.path(:rep => size) + '" ' \
                   'alt="' + item[:title] + '" ' \
                   'title="' + item[:title] + '" />'
        return img
    end

end

include ImageHelper
