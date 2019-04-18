Nanoc::Check.define(:no_todos) do
    @output_filenames.each do |filename|
        if filename =~ /html$/ && File.read(filename).match(/TODO/)
            add_issue("TODO string detected", subject: filename)
        end
    end
end

Nanoc::Check.define(:space_before_unit) do
    exceptions = [
        "2200G"
    ]
    @output_filenames.each do |filename|
        if filename =~ /html$/
            File.read(filename).match(/\s([0-9]+[a-zA-Z]+)\s/) do |match|
                m = match.to_s
                m.strip!
                if m.end_with? "th" or m.end_with? "st"
                    # Probably a date
                    next
                end
                if exceptions.include? m
                    next
                end
                add_issue("Possible space needed between number and unit: " + m, subject: filename)
            end
        end
    end
end
