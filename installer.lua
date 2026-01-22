local files = {
  "scanPeripherals.lua",
  "ExtremeReactor.lua",
  "main",
  "ExtremeTurbine.lua",
}

local base =
  "https://raw.githubusercontent.com/tuneyourdrums/ExtremeReactors/refs/heads/main/"

for _, file in ipairs(files) do
  shell.run("rm", file)
  print("Downloading " .. file)
  shell.run("wget", base .. file, file)
end

print("Install complete!")