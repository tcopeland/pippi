require 'pippi'

module Pippi
  class Documentation
    def generate
      str = ""
      [Pippi::Checks::SelectFollowedBySize::Documentation,
       Pippi::Checks::SelectFollowedByFirst::Documentation,
       Pippi::Checks::ReverseFollowedByEach::Documentation,
       Pippi::Checks::MapFollowedByFlatten::Documentation,
       Pippi::Checks::AssertWithNil::Documentation,
      ].sort {|a,b| a.name <=> b.name }.each do |clz|
        obj = clz.new
        str << %Q{
### #{clz.name.to_s.split('::')[2]}

#{obj.description}

For example, rather than doing this:

\`\`\`ruby
#{obj.sample}
\`\`\`

Instead, consider doing this:

\`\`\`ruby
#{obj.instead_use}
\`\`\`
}
      end
      File.open("doc/docs.md", "w") {|f| f.syswrite(str) }
    end
  end
end

namespace :pippi do
  desc "Generate check documentation"
  task :generate_docs do
    Pippi::Documentation.new.generate
  end
end
