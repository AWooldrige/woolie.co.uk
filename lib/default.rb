# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require 'date'
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::XMLSitemap
use_helper Nanoc::Helpers::Rendering
use_helper Nanoc::Helpers::Blogging
