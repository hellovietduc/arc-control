#!/usr/bin/osascript

-- https://github.com/raycast/extensions/blob/b4c38bd2ccd64e1eec5ec96d9e75ef66faac133c/extensions/arc/src/arc.ts#L8-L15
on escape_string(_text)
  set AppleScript's text item delimiters to the "\""
  set the item_list to every text item of _text
  set AppleScript's text item delimiters to the "\\\""
  set _text to the item_list as string
  set AppleScript's text item delimiters to ""
  return _text
end

-- https://www.alfredapp.com/help/workflows/inputs/script-filter/json/
on build_item(_space_title, _tab_title, _tab_url, _arg)
  set _item_title to "\"title\":\"" & _tab_title & "\","
  set _item_subtitle to "\"subtitle\":\"" & _space_title & " ¥ " & _tab_url & "\","
  set _item_arg to "\"arg\":" & _arg & ","
  set _item_match to "\"match\":\"" & _tab_title & " " & _tab_url & "\","
  set _item_mods to "\"mods\":{\"cmd\":{\"valid\":true,\"arg\":\"" & _tab_url & "\",\"subtitle\":\"Press Cmd+C to copy URL\"}},"
  set _item_text to "\"text\":{\"copy\":\"" & _tab_url & "\"}"
  return "{" & _item_title & _item_subtitle & _item_arg & _item_match & _item_mods & _item_text & "}"
end

set _output to ""

-- https://browserinc.notion.site/Arc-AppleScript-API-897272210c784627ba3925a7610b02b6
tell application "Arc"
  set _window_index to 1

  repeat with _window in windows
    set _space_index to 1

    repeat with _space in spaces of _window
      set _tab_index to 1
      set _tab_count to count tabs of _space
      set _space_title to my escape_string(get title of _space)

      repeat with _tab in tabs of _space
        set _tab_title to my escape_string(get title of _tab)
        set _tab_url to get URL of _tab

        set _arg to ("[" & _window_index & "," & _space_index & "," & _tab_index & "]")
        set _item to my build_item(_space_title, _tab_title, _tab_url, _arg)
        set _output to (_output & _item)

        if _tab_index <= _tab_count then
          set _output to (_output & ",")
        end if

        set _tab_index to _tab_index + 1
      end repeat

      set _space_index to _space_index + 1
    end repeat

    set _window_index to _window_index + 1
  end repeat
end tell

return "{\"items\":[" & _output & "]}"
