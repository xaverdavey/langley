let multi_line_new_line comment lexbuf =
  let line_count = (List.length (String.split_on_char '\n' comment)) - 1 in
  for _ = 1 to line_count do Lexing.new_line lexbuf done
