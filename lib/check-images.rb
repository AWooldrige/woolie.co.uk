require 'exif'

Nanoc::Check.define(:no_geotags) do
    @output_filenames.each do |filename|
        if filename.downcase =~ /(jpg|jpeg)$/
            begin
                data = Exif::Data.new(File.open(filename))
                if ! data[:gps].empty?
                    puts data[:gps]
                    add_issue("Geotags detected", subject: filename)
                end
            rescue Exif::NotReadable
                # puts 'Could not read any EXIF from: ' + filename
            end
        end
    end
end
