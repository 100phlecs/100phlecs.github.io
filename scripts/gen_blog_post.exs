[name] = System.argv()

date =
  Date.utc_today()
  |> Date.to_string()

header = """
+++
title = 'new title'
+++
"""

path = "content/blog/#{date}-#{name}.md"
File.write!(path, header)
