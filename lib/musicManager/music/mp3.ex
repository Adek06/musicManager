defmodule Mp3 do

  require Bitwise
  use Bitwise

  def cal_size(2, bytes) do
    << byte1, byte2, byte3 >> = bytes
    byte3 + (byte2<<<7) + (byte1<<<14)
  end

  def cal_size(_, bytes) do
    << byte1, byte2, byte3, byte4 >> = bytes
    byte4 + (byte3<<<7) + (byte2<<<14) + (byte1<<<21)
  end
  

  def header(contents) do
    << "ID3",
      version :: binary-size(2),
      flags :: integer-8,
      size :: binary-size(4),
      _ :: binary >> = contents
    << versionMajor, versionMinor >> = version
    tag_size = cal_size(1, size)
    %{
      version: {versionMajor, versionMinor},
      flags: "",
      size: tag_size
    }
  end

  def frames(bytes) do
    %{size: size, version: version} = header(bytes)
    << _ :: binary-size(10), framedata :: binary-size(size), _ :: binary >> = bytes
    versionMajor = elem version, 0
    IO.puts versionMajor
    read_frame(versionMajor, framedata)
  end

  @doc """
  Read frame context

  ## Parameters

    - reversion: v2.2(v2.0) is diffrent with v2.3 and v2.4
    - data: frames data

  ## Examples

      iex> Mp3.read_frame(0, bytes)
      %{}
  """
  @spec read_frame(Integer.t(), Binary.t()) :: %{}
  def read_frame(_, <<0, _ :: binary>>) do
    %{}
  end

  def read_frame(2, data) do
    << frame_header :: binary-size(6), rest :: binary >> = data
    << identifier :: binary-size(3), size :: binary-size(3) >> = frame_header

    frame_info_size = cal_size(2, size)
    << content :: binary-size(frame_info_size), another :: binary >> = rest

    IO.puts identifier
    Enum.join(for <<c::utf8 <- content>>, do: <<c::utf8>>) |> IO.puts

    read_frame(2, another)
  end

  def read_frame(_, data) do
    << frame_header :: binary-size(10), rest :: binary >> = data
    << frame_type :: binary-size(4), size :: binary-size(4), flag :: binary-size(3)>> = frame_header
    tag_size = cal_size(1, size)
  end

  def tags() do
  end
  
  def parse(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        IO.inspect frames(binary)
      _ ->
        IO.puts "Can't not open #{filename}"
    end
  end

end
