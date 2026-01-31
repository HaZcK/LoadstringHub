-- loader.lua
-- Strictly uses loadstring to fetch and run scripts from the repo.
-- Runs each script in a shared environment so scripts can communicate (e.g. base.lua & playermanager.lua).
-- Intended as a LocalScript. HttpService must be enabled.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Repo info
local REPO_OWNER = "HaZcK"
local REPO_NAME  = "LoadstringHub"
local REF        = "e66c2cf1dc7321010a5318c9e873cbf314b8c940" -- commit/branch/tag
local DIR_PATH   = "ScriptHub/Teleport"

-- Files to load (order matters)
local FILES = {
    "base.lua",
    "playermanager.lua",
}

local RAW_PATTERN = "https://raw.githubusercontent.com/%s/%s/%s/%s/%s"
local function buildUrl(filename)
    return string.format(RAW_PATTERN, REPO_OWNER, REPO_NAME, REF, DIR_PATH, filename)
end

-- Require loadstring
if type(loadstring) ~= "function" then
    error("loadstring is required by this loader but is not available in this environment.")
end

if not HttpService.HttpEnabled then
    warn("HttpService.HttpEnabled is false. Enable it to allow loader to fetch scripts.")
end

-- Shared environment for loaded scripts
local sharedEnv = {}
-- populate sane globals that scripts commonly expect
sharedEnv.game = game
sharedEnv.workspace = workspace
sharedEnv.Players = Players
sharedEnv.LocalPlayer = LocalPlayer
sharedEnv.print = print
sharedEnv.pcall = pcall
sharedEnv.wait = wait
sharedEnv.pairs = pairs
sharedEnv.ipairs = ipairs
sharedEnv.RBXScriptSignal = nil -- placeholder if needed
-- Allow loaded code to require user scripts to set values back to this table
sharedEnv._G = _G -- keep access to global table if scripts expect it

-- Helper to set environment for chunk (supports setfenv or load with env if available)
local function set_chunk_env(chunk, env)
    if type(setfenv) == "function" then
        -- Lua 5.1 style
        setfenv(chunk, env)
        return chunk
    else
        -- attempt Lua 5.2+ style load with env (some exploit runtimes support this)
        -- chunk is a function returned by loadstring; try to re-load via load if available
        if type(load) == "function" then
            local ok, reloaded = pcall(function()
                -- attempt to get source from chunk via tostring fallback is not reliable,
                -- so we try to return chunk unchanged (best-effort). If environment can't be set, we'll still run chunk.
                return chunk
            end)
            if ok and type(reloaded) == "function" then
                return reloaded
            end
        end
        -- fallback: return chunk as-is (may use global env)
        return chunk
    end
end

local function fetchAndRun(filename)
    local url = buildUrl(filename)
    local ok, content = pcall(function()
        return HttpService:GetAsync(url, true)
    end)
    if not ok or not content then
        return false, ("Failed to fetch %s: %s"):format(url, tostring(content))
    end

    local okChunk, chunkOrErr = pcall(function()
        return loadstring(content)
    end)
    if not okChunk or type(chunkOrErr) ~= "function" then
        return false, ("Compilation error for %s: %s"):format(filename, tostring(chunkOrErr))
    end

    local chunk = chunkOrErr
    -- set chunk environment if possible
    chunk = set_chunk_env(chunk, sharedEnv) or chunk

    local success, result = pcall(function()
        return chunk()
    end)

    if not success then
        return false, ("Runtime error in %s: %s"):format(filename, tostring(result))
    end

    return true
end

-- Load files
for _, fname in ipairs(FILES) do
    local ok, err = fetchAndRun(fname)
    if ok then
        print(("Loaded %s via loadstring"):format(fname))
    else
        warn(("Failed to load %s: %s"):format(fname, tostring(err)))
    end
end

print("Teleport loader finished.")    local ok, content = pcall(function()
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
