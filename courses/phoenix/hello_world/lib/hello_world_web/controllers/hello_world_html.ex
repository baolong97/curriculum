defmodule HelloWorldWeb.HelloWorldHTML do
  use HelloWorldWeb, :html

  embed_templates "hello_world_html/*"
end
