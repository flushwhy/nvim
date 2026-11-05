local alpha = require "alpha"
local dashboard = require "alpha.themes.dashboard"

dashboard.section.header.val = {
  "                                                        ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ",
  "                                                        ",
  "                 A focused workspace                   ",
}
dashboard.section.header.opts.hl = "AlphaHeader"

dashboard.section.buttons.val = {
  dashboard.button("f", "󰍉  Find file", ":Telescope find_files<CR>"),
  dashboard.button("r", "󱋡  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("w", "󰩉  Find word", ":Telescope live_grep<CR>"),
  dashboard.button("n", "󰝒  New file", ":ene <BAR> startinsert<CR>"),
  dashboard.button("b", "󰉋  File browser", ":NvimTreeToggle<CR>"),
  dashboard.button("s", "󰑬  Read updates", "<cmd>lua require('configs.rss_reader').open()<CR>"),
}
dashboard.section.buttons.opts.hl = "AlphaButtons"

local rss_section = {
  type = "text",
  val = { "", "  󰑬  Latest Updates" },
  opts = { hl = "AlphaFooter", position = "center" },
}

local function human_age(ts)
  if not ts then return "?" end
  local diff = os.time() - ts
  if diff < 60 then return diff .. "s"
  elseif diff < 3600 then return math.floor(diff / 60) .. "m"
  elseif diff < 86400 then return math.floor(diff / 3600) .. "h"
  elseif diff < 604800 then return math.floor(diff / 86400) .. "d"
  else return math.floor(diff / 604800) .. "w" end
end

local function build_rss_lines(entries)
  local lines = { "  ╠══════════════════════════════════════════════════════════════════╣" }
  local shown = 0
  for _, entry in ipairs(entries) do
    if shown >= 5 then break end
    local feed = string.format("%-8s", (entry.feed_name or "?"):sub(1, 8))
    local age = string.format("%4s", human_age(entry.published))
    local title = entry.title or "(no title)"
    if #title > 42 then title = title:sub(1, 40) .. "…" end
    lines[#lines + 1] = string.format("  │ %s  %-42s  %s │", feed, title, age)
    shown = shown + 1
  end
  if shown == 0 then
    lines[#lines + 1] = "  │ No updates cached yet — run :CustomRss refresh                  │"
  end
  lines[#lines + 1] = "  ╚══════════════════════════════════════════════════════════════════╝"
  lines[#lines + 1] = ""
  return lines
end

local function update_feed(entries)
  rss_section.val = build_rss_lines(entries or {})
  if vim.bo.filetype == "alpha" then alpha.redraw() end
end

local function make_footer()
  local stats = require("lazy").stats()
  return {
    "  ⚡ " .. stats.loaded .. " plugins  ·  " .. math.floor(stats.startuptime * 100 + 0.5) / 100 .. "ms startup",
    "",
  }
end

dashboard.section.footer.val = make_footer()
dashboard.section.footer.opts = { hl = "AlphaFooter", position = "center" }
dashboard.config.layout = {
  { type = "padding", val = 1 },
  dashboard.section.header,
  { type = "padding", val = 1 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  rss_section,
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

vim.defer_fn(function()
  local ok, rss = pcall(require, "customrss")
  if not ok then return end
  local cached = rss.get_entries()
  if cached and #cached > 0 then update_feed(cached) end
  rss.refresh(function(entries) update_feed(entries) end)
end, 50)

vim.api.nvim_create_autocmd("User", {
  pattern = "CustomRssUpdated",
  callback = function(args)
    if args.data and args.data.entries then update_feed(args.data.entries) end
  end,
})
