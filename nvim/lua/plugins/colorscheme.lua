return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
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
      opts.colorscheme = appearance == "dark" and "catppuccin-macchiato" or "catppuccin-latte"

      -- Auto-refresh on focus (detects OS theme changes)
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          local new_appearance = get_os_appearance()
          if new_appearance ~= appearance then
            appearance = new_appearance
            vim.cmd.colorscheme(appearance == "dark" and "catppuccin-macchiato" or "catppuccin-latte")
          end
        end,
      })
    end,
  },
}
