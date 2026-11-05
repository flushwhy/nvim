local M = {}

local function open_url(url)
  if not url then return end
  local sys = vim.uv.os_uname().sysname
  local cmd = sys:find("Windows") and { "cmd", "/c", "start", "", url }
    or sys == "Darwin" and { "open", url }
    or { "xdg-open", url }
  vim.fn.jobstart(cmd, { detach = true })
end

function M.open()
  local ok, rss = pcall(require, "customrss")
  if not ok then
    vim.notify("RSS plugin is not available.", vim.log.levels.ERROR)
    return
  end

  local entries = rss.get_entries() or {}
  if #entries == 0 then
    vim.notify("Refreshing feeds…", vim.log.levels.INFO)
    rss.refresh(function(updated)
      if updated and #updated > 0 then M.open()
      else vim.notify("No feed entries available.", vim.log.levels.WARN) end
    end)
    return
  end

  local lines = {}
  for _, entry in ipairs(entries) do
    local title = (entry.title or "(untitled)"):gsub("[%c]", " ")
    lines[#lines + 1] = string.format("%-9s %s", (entry.feed_name or "?"):sub(1, 9), title)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = math.min(110, math.max(60, vim.o.columns - 8))
  local height = math.min(24, math.max(8, vim.o.lines - 8))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Updates  [Enter] open  [r] refresh  [q] close ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end

  local function open_current()
    local entry = entries[vim.api.nvim_win_get_cursor(win)[1]]
    if entry then
      open_url(entry.link)
      if entry.id and rss.mark_read then rss.mark_read(entry.id) end
    end
  end

  local function refresh()
    vim.notify("Refreshing feeds…", vim.log.levels.INFO)
    rss.refresh(function(updated)
      entries = updated or {}
      lines = {}
      for _, entry in ipairs(entries) do
        lines[#lines + 1] = string.format("%-9s %s", (entry.feed_name or "?"):sub(1, 9), (entry.title or "(untitled)"):gsub("[%c]", " "))
      end
      vim.bo[buf].modifiable = true
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false
      vim.api.nvim_win_set_cursor(win, { 1, 0 })
    end)
  end

  local opts = { buffer = buf, silent = true, nowait = true }
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("n", "<CR>", open_current, opts)
  vim.keymap.set("n", "o", open_current, opts)
  vim.keymap.set("n", "r", refresh, opts)
end

return M
