defmodule ID3v2 do

  require Bitwise
  use Bitwise

  # base on https://github.com/Cheezmeister/elixir-id3v2/blob/master/lib/id3v2.ex
  defmodule FrameHeaderFlags do
    defstruct [
      :tag_alter_preservation,
      :file_alter_preservation,
      :read_only,
      :grouping_identity,
      :compression,
      :encryption,
      :unsynchronisation,
      :data_length_indicator,
    ]

    @tag_alter_preservation_bit (1 <<< 15)
    @file_alter_preservation_bit (1 <<< 14)
    @read_only_bit (1 <<< 13)
    @grouping_identity_bit 16
    @compression_bit 8
    @encryption_bit 4
    @unsynchronisation_bit 2
    @data_length_indicator_bit 1

    def read(<<doublebyte::integer-16>>) do
      %FrameHeaderFlags{
        tag_alter_preservation: 0 != (doublebyte &&& @tag_alter_preservation_bit),
        file_alter_preservation: 0 != (doublebyte &&& @file_alter_preservation_bit),
        read_only: 0 != (doublebyte &&& @read_only_bit),
        tag_alter_preservation: 0 != (doublebyte &&& @tag_alter_preservation_bit),
        file_alter_preservation: 0 != (doublebyte &&& @file_alter_preservation_bit),
        read_only: 0 != (doublebyte &&& @read_only_bit),
        grouping_identity: 0 != (doublebyte &&& @grouping_identity_bit),
        compression: 0 != (doublebyte &&& @compression_bit),
        encryption: 0 != (doublebyte &&& @encryption_bit),
        unsynchronisation: 0 != (doublebyte &&& @unsynchronisation_bit),
        data_length_indicator: 0 != (doublebyte &&& @data_length_indicator_bit),
      }
    end

  end
  
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
    IO.puts "version is: #{versionMajor}\n"
    read_frame(versionMajor, framedata)
  end

  @doc """
  Read frame context

  ## Parameters

    - MajorVersion: v2.2(v2.0) is diffrent with v2.3 and v2.4
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
    << content :: binary-size(frame_info_size), another_frames :: binary >> = rest

    IO.puts identifier
    Enum.join(for <<c::utf8 <- content>>, do: <<c::utf8>>) |> IO.puts

    read_frame(2, another_frames)
  end

  def read_frame(version, data) do
    << frame_header :: binary-size(10), rest :: binary >> = data
    << frame_type :: binary-size(4), size :: binary-size(4), flags :: binary-size(2)>> = frame_header

    flags = FrameHeaderFlags.read flags

    payload_size = case version do
                     4 -> cal_size(version, size)
                     _ -> raise "ID3v2.#{version} not supported"
                   end
    
    << payload :: binary-size(payload_size), another_frames :: binary >> = rest

    # TODO handle more flags
    payload = if flags.unsynchronisation do
      p = if flags.data_length_indicator do
        <<_size::integer-32, p::binary>> = payload; p
      else
        payload
      end
      strip_zero_bytes p
    else
      payload
    end

    value = read_payload(frame_type, payload) |> strip_zero_bytes
    
    #IO.puts frame_type
    #IO.inspect value
    #IO.puts "\n"
    
    Map.merge(%{frame_type => value}, read_frame(version, another_frames))
  end

  def strip_zero_bytes(<<h, t::binary>>) do
    case h do
      0 -> t
      _ -> << h, strip_zero_bytes(t)::binary>>
    end
  end

  def strip_zero_bytes(<<h>>) do
    case h do
      0 -> <<>>
      _ -> h
    end
  end

  def strip_zero_bytes(<<>>) do
    <<>>
  end

  def read_payload(key, payload) do
    << _encoding :: integer-8, _rest :: binary>> = payload

    # Special case nonsense goes here
    case key do
      "WXXX" -> read_user_url payload
      "TXXX" -> "" # TODO read_user_text payload
      "APIC" -> "" # TODO Handle embedded JPEG data?
      _ -> read_standard_payload payload
    end
  end

  defp read_standard_payload(payload) do
    << encoding :: integer-8, rest :: binary>> = payload
    # TODO Handle optional 3-byte language prefix
    case encoding do
      0 -> rest
      1 -> read_utf16 rest
      2 -> raise "I don't support utf16 without a bom"
      3 -> rest
      _ -> payload
    end
  end

  def read_user_url(payload) do
    # TODO bubble up description somehow
    {_description, link, _bom} = extract_null_terminated payload
    link
  end

  def read_user_text(payload) do
    {_description, text, bom} = extract_null_terminated payload
    case bom do
      nil -> text
      _ -> read_utf16 bom, text
    end
  end

  def extract_null_terminated(<< 1, rest::binary >>) do
    << bom :: binary-size(2), content :: binary >> = rest
    {description, value} = scan_for_null_utf16 content, []
    {description, value, bom}
  end

  def extract_null_terminated(<< encoding::integer-8, content::binary >>) do
    {description, value} = case encoding do
      0 -> scan_for_null_utf8 content, []
      3 -> scan_for_null_utf8 content, []
      _ -> raise "I don't support that text encoding (encoding was #{encoding})"
    end
    {description, value, nil}
  end

  # Based on https://elixirforum.com/t/scanning-a-bitstring-for-a-value/1852/2
  defp scan_for_null_utf16(<< c::utf16, rest::binary >>, accum) do
    case c do
      0 -> {to_string(Enum.reverse accum), rest}
      _ -> scan_for_null_utf16 rest, [c | accum]
    end
  end

  defp scan_for_null_utf8(<<c::utf8, rest::binary>>, accum) do
    case c do
      0 -> {to_string(Enum.reverse accum), rest}
      _ -> scan_for_null_utf8 rest, [c | accum]
    end
  end

  def read_utf16("") do
    ""
  end

  def read_utf16(<< bom :: binary-size(2), content :: binary >>) do
    read_utf16 bom, content
  end

  def read_utf16(bom, content) do
    {encoding, _charsize} = :unicode.bom_to_encoding(bom)
    :unicode.characters_to_binary content, encoding
  end

  def tags() do
  end
  
  def parse(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        frames(binary)
      _ ->
        IO.puts "Can't not open #{filename}"
    end
  end

end

