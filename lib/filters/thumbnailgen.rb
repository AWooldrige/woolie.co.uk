require 'exif'

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

    def imageThumbnail(itemIdentifier, size=:default, caption=true)
        item = @items[itemIdentifier]

        # TODO: Error out descriptively if title or caption don't exist
        html = '<img src="' + item.path(:rep => size) + '" alt="' + item[:title] + '" />'
        html = '<a href="' + item.path + '">' + html + '</a>'
        if caption
            html = '<figure class="captioned-image">' + html + '<figcaption>' + item[:caption] + '</figcaption></figure>'
        end
        return html
    end

    def imageVerbatim(itemIdentifier, caption=false)
        item = @items[itemIdentifier]
        html = '<img src="' + item.path + '" ' \
                   'alt="' + item[:title] + '" />'
        if caption
            html = '<figure class="captioned-image">' + html + '<figcaption>' + item[:caption] + '</figcaption></figure>'
        end
        return html
    end

end

include ImageHelper
