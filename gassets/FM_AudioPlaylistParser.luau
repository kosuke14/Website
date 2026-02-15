local data = game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/kosuke14/Website/refs/heads/main/gassets/FM_AudioIds.txt", true)
type MusicLineInfo = {Id: string, Playlist: string, ArtistName: string, Title: string, _line: string}
local r: { MusicLineInfo } = {}
local revSplit = {"－", " %- "}
local straightSplit = {" / "}
local list = ""
for _, v in next, data:split("\n") do
  if v:sub(1, 3) == "-- " then
    list = v:sub(4, -1)
  end
  if v:match("%d+ %-") then
    local info = {} :: MusicLineInfo
    info.Id = v:match("%d+") :: string
    info.Playlist = list
    local names = v:gsub(".*%d+ %-%s", "")
    for _, key in next, revSplit do
      if names:match(key) then
        info.ArtistName = names:gsub(key .. ".*", "")
        info.Title = names:gsub(".*" .. key, "")
        break
      end
    end
    if not (info.Title and info.ArtistName) then
      for _, key in next, straightSplit do
        if names:match(key) then
          info.ArtistName = names:gsub(".*" .. key, "")
          info.Title = names:gsub(key .. ".*", "")
          break
        end
      end
    end
    if not (info.Title and info.ArtistName) then
      info.Title = names
      info.ArtistName = ""
    end
    info._line = v
    table.insert(r, info)
  end
end

print(game:GetService("HttpService"):JSONEncode(r))
