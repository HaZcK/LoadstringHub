-- loader.lua
-- Fetches and runs all Teleport scripts from the repository using HttpService + loadstring.
-- Designed to be executed as a LocalScript (or in an environment that provides HttpService and loadstring).

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Repo info (adjust these if you want to load from a different branch/commit)
local REPO_OWNER = "HaZcK"
local REPO_NAME  = "LoadstringHub"
local REF        = "e66c2cf1dc7321010a5318c9e873cbf314b8c940" -- commit/branch/tag
local DIR_PATH   = "ScriptHub/Teleport" -- path inside the repo

-- Files to load from that folder (add/remove names as needed)
local FILES = {
    "base.lua",
    "playermanager.lua",
}

-- Raw content URL pattern for raw.githubusercontent.com
local RAW_PATTERN = "https://raw.githubusercontent.com/%s/%s/%s/%s/%s" 
-- format: owner, repo, ref, dir_path, filename

local function buildUrl(filename)
    return string.format(RAW_PATTERN, REPO_OWNER, REPO_NAME, REF, DIR_PATH, filename)
end

-- Helper to fetch a file over HTTP and run it with loadstring
local function fetchAndRun(filename)
    local url = buildUrl(filename)
    if not HttpService.HttpEnabled then
        warn(("HttpService is not enabled. Cannot fetch %s from %s"):format(filename, url))
        return false, "HttpDisabled"
    end

    local ok, content = pcall(function()
        return HttpService:GetAsync(url, true) -- nocache=true to ensure latest
    end)
    if not ok then
        warn(("Failed to fetch %s: %s"):format(url, tostring(content)))
        return false, content
    end

    -- Prefer loadstring if available, otherwise fall back to load
    local chunk, loadErr
    if type(loadstring) == "function" then
        chunk, loadErr = loadstring(content)
    else
        chunk, loadErr = load(content)
    end

    if not chunk then
        warn(("Failed to compile %s: %s"):format(filename, tostring(loadErr)))
        return false, loadErr
    end

    local success, result = pcall(function()
        -- Execute the chunk in protected call so one failing script won't stop the loader
        return chunk()
    end)

    if not success then
        warn(("Error executing %s: %s"):format(filename, tostring(result)))
        return false, result
    end

    return true
end

-- Run all files in order
for _, fname in ipairs(FILES) do
    local ok, err = fetchAndRun(fname)
    if ok then
        print(("Loaded %s successfully."):format(fname))
    else
        warn(("Failed to load %s: %s"):format(fname, tostring(err)))
    end
end

print("Loader finished.")
