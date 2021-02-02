defmodule Mp3 do
  def parse(filename) do
    case File.read(filename) do
      {:ok, binary} ->
        IO.puts byte_size(binary)
        # 获取Mp3音频数据的大小,用于计算ID3的起始偏移量
        _ = (byte_size(binary) - 128) * 8
        # 把我们需要的部分解析出来
        << head :: bitstring-size(80), _ :: binary >> = binary
        IO.puts head
        << "ID3", version :: bitstring-size(16), _ :: binary >> = head
        IO.puts version
#        case id3_tag do
#          <<"TAG", tags :: binary>> ->
#            # 从id3_tag中匹配出标题,艺术家名称,专辑名称,发行年份, 评论, 等
#            << title   :: binary-size(30),
#               artist  :: binary-size(30),
#               album   :: binary-size(30),
#               year    :: binary-size(4),
#               comment :: binary-size(30),
#               genre   :: binary-size(1)
#            >>  = id3_tag
#            # 输出
#            IO.puts tags
#            IO.puts "标题名: #{title}"
#            IO.puts "艺术家: #{artist}"
#            IO.puts "专辑名: #{album}"
#            IO.puts "年份: #{year}"
#            IO.puts "评论: #{comment}"
#            IO.puts "流派: #{genre}"
#          _ ->
#            :NO_TAG_INFORMATION
#        end        
      _ ->
        IO.puts "Can't not open #{filename}"
    end
  end
end
