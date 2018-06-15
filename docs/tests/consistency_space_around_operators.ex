##Patterns: consistency_space_around_operators
defmodule Credo.Sample1 do
  defmodule InlineModule do
    @min -1
    @max +1
    @type config_or_func :: Config.t() | (-> Config.t())

    def foobar do
     ##Warning: consistency_space_around_operators
      1+2
    end
  end
end

defmodule Credo.Sample2 do
  defmodule InlineModule do
    @type config_or_func :: Config.t() | (-> Config.t())

    # Fine
    defp format_value("NPC_", "NPDT", <<skills::binary-27>>) do
    end

    # Gives warning
    defp format_value("NPC_", "NPDT", <<stuff::integer, other_stuff::integer, even_more_stuff::integer,
      skills::binary-27>>) do


      skip = (SourceFile.column(source_file, line_no, text) || -1) + name_size
    end

    defp parse_image_stats(<< @gif_89_signature,
      width::little-integer-size(16),
      height::little-integer-size(16),
      _remainder::binary >>) do
      %{ filetype: :gif,
        width: width,
        height: height }
    end

    def foo do
      <<_, unquoted::binary-size(size), _>> = quoted
      <<data::size(len)-binary, _::binary>>
      <<102::integer-native, rest::binary>>
      <<102::native-integer, rest::binary>>
      <<102::unsigned-big-integer, rest::binary>>
      <<102::unsigned-big-integer-size(8), rest::binary>>
      <<102::unsigned-big-integer-8, rest::binary>>
      <<102::signed-little-float-8, rest::binary>>
      <<102::8-integer-big-unsigned, rest::binary>>
      <<102, rest::binary>>
      << valsize :: 32-unsigned, rest::binary >>
    end

    def error(err_no) do
      case err_no do
        -1 -> :unknown_error
        +2 -> :known_error
        _  -> @error_map[err_no] || err_no
      end
    end

    test "date_add with negative interval" do
      dec = Decimal.new(-1)
      assert [{2013, 1, 1}] = TestRepo.all(from p in Post, select: date_add(p.posted, ^-1, "year"))
      assert [{2013, 1, 1}] = TestRepo.all(from p in Post, select: date_add(p.posted, ^-1.0, "year"))
      assert [{2013, 1, 1}] = TestRepo.all(from p in Post, select: date_add(p.posted, ^dec, "year"))
    end

    def parse_response(<< _correlation_id :: 32-signed, error_code :: 16-signed, generation_id :: 32-signed,
                         protocol_len :: 16-signed, _protocol :: size(protocol_len)-binary,
                         leader_len :: 16-signed, leader :: size(leader_len)-binary,
                         member_id_len :: 16-signed, member_id :: size(member_id_len)-binary,
                         members_size :: 32-signed, rest :: binary >>) do
      members = parse_members(members_size, rest, [])
      %Response{error_code: KafkaEx.Protocol.error(error_code), generation_id: generation_id,
                leader_id: leader, member_id: member_id, members: members}
    end

    defp int(<< value :: size(valsize)-binary >>, x) do
      case x |> Integer.parse do
        :error -> -1
        {a, _} -> a
      end
    end

    def bar do
      c = n * -1
      c = n + -1
      c = n / -1
      c = n - -1

      [(3 * 4) + (2 / 2) - (-1 * 4) / 1 - 4]
      [(3 * 4) + (2 / 2) - (-1 * 4) / 1 - 4]
      [(3 * 4) + (2 / 2) - (-1 * 4) / 1 - 4]
      |> my_func(&Some.Deep.Module.is_something/1)
    end
  end
end

defmodule OtherModule3 do
  defmacro foo do
    1 && 2
  end

  defp bar do
    :ok
  end
end

defmodule OtherModule3 do
  defmacro foo do
    case foo do
      {line_no, line} -> nil
      {line_no, line} ->
        nil
    end
  end
end

defmodule Credo.Sample1 do
  defmodule InlineModule do
    @min -1
    @max +1
    @type config_or_func :: Config.t() | (-> Config.t())

    def foobar do
     ##Warning: consistency_space_around_operators
      1+2
    end
  end
end

defmodule OtherModule3 do
  defmacro foo do
    1 && 2
  end

  defp bar do
    :ok
  end
end

defmodule OtherModule3 do
  defmacro foo do
    1 && 2
  end

  defp bar do
    :ok
  end
end

defmodule OtherModule3 do
  defmacro foo do
    ##Warning: consistency_space_around_operators
    3+4
  end

  defp bar do
    ##Warning: consistency_space_around_operators
    6 *7
  end
end

defmodule CredoTests do
def bar do
 ##Warning: consistency_space_around_operators
2+3
4 + 5
end
end

defmodule OtherModule3 do
  defmacro foo do
       ##Warning: consistency_space_around_operators
    3+4
  end

  defp bar do
       ##Warning: consistency_space_around_operators
    6 *7
  end
end

defmodule CredoTests do
def bar do
 ##Warning: consistency_space_around_operators
2+3
4 + 5
end
end
