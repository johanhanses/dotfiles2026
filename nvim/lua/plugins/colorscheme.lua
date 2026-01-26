return {
  "projekt0n/github-nvim-theme",
  name = "github-theme",
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

    require("github-theme").setup({
      options = {
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
      },
    })

    -- Load the appropriate theme based on OS appearance
    if appearance == "dark" then
      vim.cmd("colorscheme github_dark_dimmed")
    else
      vim.cmd("colorscheme github_light")
    end

    -- Auto-refresh on focus (detects OS theme changes)
    vim.api.nvim_create_autocmd("FocusGained", {
      callback = function()
        local new_appearance = get_os_appearance()
        if new_appearance ~= appearance then
          appearance = new_appearance
          if appearance == "dark" then
            vim.cmd("colorscheme github_dark_dimmed")
          else
            vim.cmd("colorscheme github_light")
          end
        end
      end,
    })
  end,
}
