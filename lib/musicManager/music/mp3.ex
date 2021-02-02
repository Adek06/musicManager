defmodule Mp3 do

  require Bitwise
  use Bitwise
  
  def head(contents) do
    << "ID3",
      version :: binary-size(2),
      flags :: integer-8,
      size :: binary-size(4),
      _ :: binary >> = contents
    << versionMajor, versionMinor >> = version
    << byte1, byte2, byte3, byte4 >> = size
    tag_size = byte4 + (byte3<<<7) + (byte2<<<14) + (byte1<<<21)
    %{
      version: {versionMajor, versionMinor},
      flags: "",
      size: tag_size
    }
  end

  def tags() do
  end
  
  def parse(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        IO.inspect head(binary) 
      _ ->
        IO.puts "Can't not open #{filename}"
    end
  end

end

