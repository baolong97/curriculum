defmodule Greeting do
  def main(args) do
    {opts, _word, _errors} = OptionParser.parse(args, switches: [time: :string, upcase: :boolean ])
    output = "Good #{opts[:time] || "morning"}!"
    output = if opts[:upcase] do
     String.upcase(output)
    else
      output
    end
    IO.puts(output)
  end
end
