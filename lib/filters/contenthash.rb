require 'digest/sha1'
def contenthash(item)
    return 'dev' if ENV['NANOC_ENV'] == 'dev'
    content = item.binary? ? File.read(item[:filename]) : item.raw_content
    return Digest::SHA1.hexdigest(content)[0..20]
end
