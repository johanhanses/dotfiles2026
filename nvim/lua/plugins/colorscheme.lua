return {
  "navarasu/onedark.nvim",
  name = "onedark",
  lazy = false,
  priority = 1000,
  config = function()
    -- Check OS theme preference
    local function get_os_appearance()
      if vim.fn.has("macunix") == 1 then
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          return result:match("Dark") and "dark" or "light"
        end
      elseif vim.fn.has("unix") == 1 then
        local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          if result:match("dark") then
            return "dark"
          end
        end
      end
      return "light"
    end

    local appearance = get_os_appearance()

    require("onedark").setup({
      style = appearance == "dark" and "dark" or "light",
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },
    })

    require("onedark").load()

    -- Auto-refresh on focus (detects OS theme changes)
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        local new_appearance = get_os_appearance()
        if new_appearance ~= appearance then
          appearance = new_appearance
          require("onedark").setup({
            style = appearance == "dark" and "dark" or "light",
          })
          require("onedark").load()
        end
      end,
    })
  end,
}
