local M = {}

local function strip_html(html)
  if not html then return "" end
  local text = html
    :gsub("<script[^>]*>.-</script>", "")
    :gsub("<style[^>]*>.-</style>", "")
    :gsub("<br%s*/?>", "\n")
    :gsub("</?p[^>]*>", "\n\n")
    :gsub("</?div[^>]*>", "\n")
    :gsub("</?li[^>]*>", "\n  • ")
    :gsub("<[^>]+>", "")
    :gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">")
    :gsub("&quot;", '"'):gsub("&#39;", "'"):gsub("&nbsp;", " ")
    :gsub("\r\n", "\n"):gsub("\r", "\n")
    :gsub("[ \t]+", " "):gsub("\n[ \t]+", "\n")
    :gsub("\n\n\n+", "\n\n")
  return text:match("^%s*(.-)%s*$")
end

local function wrap_text(text, width)
  local lines = {}
  for paragraph in (text .. "\n"):gmatch("(.-)\n") do
    if paragraph:match("^%s*$") then
      lines[#lines + 1] = ""
    else
      local line = ""
      for word in paragraph:gmatch("%S+") do
        if line == "" then
          line = word
        elseif #line + #word + 1 <= width then
          line = line .. " " .. word
        else
          lines[#lines + 1] = line
          line = word
        end
      end
      if line ~= "" then lines[#lines + 1] = line end
    end
  end
  return lines
end

local function age_label(timestamp)
  if not timestamp then return "  ?" end
  local age = math.max(0, os.time() - timestamp)
  if age < 60 then return string.format("%3ds", age) end
  if age < 3600 then return string.format("%3dm", math.floor(age / 60)) end
  if age < 86400 then return string.format("%3dh", math.floor(age / 3600)) end
  if age < 604800 then return string.format("%3dd", math.floor(age / 86400)) end
  return string.format("%3dw", math.floor(age / 604800))
end

local function open_url(url)
  if not url then
    vim.notify("No link for this entry.", vim.log.levels.WARN)
    return
  end
  local system = vim.uv.os_uname().sysname
  local command
  if system:find("Windows") then command = { "cmd", "/c", "start", "", url }
  elseif system == "Darwin" then command = { "open", url }
  else command = { "xdg-open", url } end
  vim.fn.jobstart(command, { detach = true })
end

function M.open()
  local ok, rss = pcall(require, "customrss")
  if not ok then
    vim.notify("RSS plugin is not available.", vim.log.levels.ERROR)
    return
  end

  local entries = rss.get_entries() or {}
  if #entries == 0 then
    vim.notify("No entries cached; refreshing feeds…", vim.log.levels.INFO)
    rss.refresh(function(updated)
      if updated and #updated > 0 then M.open()
      else vim.notify("Feeds returned no entries.", vim.log.levels.WARN) end
    end)
    return
  end

  local ui = vim.api.nvim_list_uis()[1]
  if not ui then return end
  local win_height = math.max(8, math.floor(ui.height * 0.88))
  local win_width = math.max(40, math.floor(ui.width * 0.92))
  win_height = math.min(win_height, ui.height - 2)
  win_width = math.min(win_width, ui.width - 2)
  local list_width = math.max(22, math.floor(win_width * 0.36))
  list_width = math.min(list_width, win_width - 18)
  local content_width = win_width - list_width - 1
  local row = math.floor((ui.height - win_height) / 2)
  local col = math.floor((ui.width - win_width) / 2)

  local list_buf = vim.api.nvim_create_buf(false, true)
  local content_buf = vim.api.nvim_create_buf(false, true)
  for _, buf in ipairs({ list_buf, content_buf }) do
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
  end

  local list_win = vim.api.nvim_open_win(list_buf, true, {
    relative = "editor", row = row, col = col,
    width = list_width, height = win_height,
    style = "minimal", border = "rounded",
    title = " Feeds  [j/k] navigate  [o] open  [r] refresh  [q] close ",
    title_pos = "left",
  })
  local content_win = vim.api.nvim_open_win(content_buf, false, {
    relative = "editor", row = row, col = col + list_width + 1,
    width = content_width, height = win_height,
    style = "minimal", border = "rounded",
    title = " Article  [Tab] switch panes  [o] open in browser ",
    title_pos = "left",
  })
  vim.wo[list_win].cursorline = true

  local selected = 1
  local function list_line(entry)
    local unread = entry.read and "  " or "● "
    local feed = string.format("%-7s", (entry.feed_name or "?"):sub(1, 7))
    local title_width = math.max(8, list_width - 19)
    local title = (entry.title or "(no title)"):gsub("[%c]", " "):sub(1, title_width)
    return string.format("%s%s  %- " .. title_width .. "s  %s", unread, feed, title, age_label(entry.published))
  end

  local function render_list()
    local lines = {}
    for _, entry in ipairs(entries) do lines[#lines + 1] = list_line(entry) end
    vim.bo[list_buf].modifiable = true
    vim.api.nvim_buf_set_lines(list_buf, 0, -1, false, lines)
    vim.bo[list_buf].modifiable = false
  end

  local function render_article(index)
    local entry = entries[index]
    if not entry then return end
    local width = math.max(12, content_width - 6)
    local lines = { "", "  " .. (entry.feed_name or "") .. "  ·  " .. (entry.published_raw or "unknown date"), "" }
    for _, line in ipairs(wrap_text(entry.title or "(untitled)", width)) do
      lines[#lines + 1] = "  " .. line
    end
    lines[#lines + 1] = ""
    lines[#lines + 1] = "  " .. (entry.link or "No link")
    lines[#lines + 1] = "  " .. string.rep("─", width)
    lines[#lines + 1] = ""
    for _, line in ipairs(wrap_text(strip_html(entry.description or ""), width)) do
      lines[#lines + 1] = line == "" and "" or "  " .. line
    end
    vim.bo[content_buf].modifiable = true
    vim.api.nvim_buf_set_lines(content_buf, 0, -1, false, lines)
    vim.bo[content_buf].modifiable = false
    pcall(vim.api.nvim_win_set_cursor, content_win, { 1, 0 })
  end

  local function close()
    if vim.api.nvim_win_is_valid(list_win) then vim.api.nvim_win_close(list_win, true) end
    if vim.api.nvim_win_is_valid(content_win) then vim.api.nvim_win_close(content_win, true) end
  end
  local function move(delta)
    selected = math.max(1, math.min(#entries, selected + delta))
    pcall(vim.api.nvim_win_set_cursor, list_win, { selected, 0 })
    render_article(selected)
  end
  local function open_current()
    local entry = entries[selected]
    if not entry then return end
    open_url(entry.link)
    if entry.id and rss.mark_read then rss.mark_read(entry.id) end
    entry.read = true
    render_list()
  end
  local function refresh()
    vim.notify("Refreshing feeds…", vim.log.levels.INFO)
    rss.refresh(function(updated, errors)
      entries = updated or {}
      selected = 1
      render_list()
      render_article(1)
      if errors and #errors > 0 then
        vim.notify("Some feeds could not be refreshed.", vim.log.levels.WARN)
      else
        vim.notify("Feeds refreshed — " .. #entries .. " entries", vim.log.levels.INFO)
      end
    end)
  end
  local function map(buf, key, callback, description)
    vim.keymap.set("n", key, callback, {
      buffer = buf, nowait = true, silent = true, desc = description,
    })
  end

  render_list()
  render_article(1)
  vim.api.nvim_win_set_cursor(list_win, { 1, 0 })

  map(list_buf, "q", close, "Close reader")
  map(list_buf, "<Esc>", close, "Close reader")
  map(list_buf, "j", function() move(1) end, "Next entry")
  map(list_buf, "k", function() move(-1) end, "Previous entry")
  map(list_buf, "<Down>", function() move(1) end, "Next entry")
  map(list_buf, "<Up>", function() move(-1) end, "Previous entry")
  map(list_buf, "<CR>", open_current, "Open in browser")
  map(list_buf, "o", open_current, "Open in browser")
  map(list_buf, "r", refresh, "Refresh feeds")
  map(list_buf, "<Tab>", function() vim.api.nvim_set_current_win(content_win) end, "Focus article")
  map(content_buf, "<Tab>", function() vim.api.nvim_set_current_win(list_win) end, "Focus feed list")
  map(content_buf, "q", close, "Close reader")
  map(content_buf, "<Esc>", close, "Close reader")
  map(content_buf, "o", open_current, "Open in browser")
end

return M
