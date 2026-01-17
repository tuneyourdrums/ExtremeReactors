local files = {
  "scanPeripherals.lua",
}

local base =
  "https://raw.githubusercontent.com/tuneyourdrums/ExtremeReactors/refs/heads/main/"

for _, file in ipairs(files) do
  print("Downloading " .. file)
  shell.run("wget", base .. file, file)
end

print("Install complete!")