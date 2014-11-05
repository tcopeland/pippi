require 'pippi'

module Pippi
  class Documentation
    def generate
      str = ''
      Pippi::CheckSetMapper.new("").predefined_sets.sort.select {|k,v| v.any? }.each do |checkset_name, checks|
        str << "### #{checkset_name}\n"
        checks.sort.each do |check|
          obj = Object.const_get("Pippi::Checks::#{check}::Documentation").new
          str << %(
#### #{check}

#{obj.description}

For example, rather than doing this:

\`\`\`ruby
#{obj.sample}
\`\`\`

Instead, consider doing this:

\`\`\`ruby
#{obj.instead_use}
\`\`\`
)
        end
      end
      File.open('doc/docs.md', 'w') { |f| f.syswrite(str) }
    end
  end
end

namespace :pippi do
  desc 'Generate check documentation'
  task :generate_docs do
    Pippi::Documentation.new.generate
  end
end
