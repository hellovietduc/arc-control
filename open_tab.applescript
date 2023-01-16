#!/usr/bin/osascript

on run argv
  set _window_id to item 1 of argv as number
  set _space_id to item 2 of argv as number
  set _tab_id to item 3 of argv as number

  activate application "Arc"

  -- https://browserinc.notion.site/Arc-AppleScript-API-897272210c784627ba3925a7610b02b6
  tell application "Arc"
    tell window _window_id
      tell space _space_id
        tell tab _tab_id to select
      end tell
    end tell
  end tell
end run
