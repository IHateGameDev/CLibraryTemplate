local lfs = require("lfs")

local function copyFile(source, destination)
  local input = io.open(source, "rb")
  if not input then return false end
  local output = io.open(destination, "wb")
  if not output then
    input:close()
    return false
  end
  output:write(input:read("*all"))
  input:close()
  output:close()
  return true
end

local function matchesPattern(filename, patterns)
  if #patterns == 0 then return true end
  for _, pattern in ipairs(patterns) do
    if pattern:sub(1, 1) == "+" then
      if filename:match(pattern:sub(2)) then
        return true
      end
    elseif pattern:sub(1, 1) == "-" then
      if filename:match(pattern:sub(2)) then
        return false
      end
    end
  end
  return false
end

local function findFilesInDirectory(dir, patterns)
  local files = {}

  for file in lfs.dir(dir) do
    if file ~= "." and file ~= ".." then
      local path = dir .. '/' .. file
      local attr = lfs.attributes(path)

      if attr.mode == "directory" then
        local subFiles = findFilesInDirectory(path, patterns)
        for _, subFile in ipairs(subFiles) do
          table.insert(files, subFile)
        end
      elseif attr.mode == "file" and matchesPattern(file, patterns) then
        table.insert(files, path)
      end
    end
  end

  return files
end

local args = arg

local function showHelp()
  print("Usage: lua sync.lua <TemplateVarsFile> <TemplateDirectory> <Formats>")
  print("WARNING: Actions need to run in root repository directory!!!\n")
  print("Example: lua sync.lua TemplateVars CLibraryTemplate +%.in -README.md.in")
end

if #args < 3 then
  showHelp()
  return
end

local formats = {}
for i = 3, #args do
  table.insert(formats, args[i])
end

local resultFiles = findFilesInDirectory(args[2], formats)

for _, file in ipairs(resultFiles) do
  print("Copying: ", file)
  local success = copyFile(file, "./")
  if not success then
    print("Error copying file: ", file)
  end
end

print("Configure new template files")

local cmakeFile = args[2] .. "/CMakeLists.txt"
if lfs.attributes(cmakeFile) then
  os.execute("mkdir -p ./tmp")
  copyFile(cmakeFile, "./tmp/CMakeLists.txt")

  local templateVarsContent = io.open(args[1], "r")
  local vars = templateVarsContent:read("*all")
  templateVarsContent:close()

  os.execute("cd ./tmp && cmake . -DCONFIG_DIR=../" .. vars)

  os.execute("rm -rf ./tmp")
else
  print("CMakeLists.txt not found.")
end

