# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'date'
require 'nanoc/cachebuster'
include Nanoc::Helpers::CacheBusting
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::XMLSitemap
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Blogging
