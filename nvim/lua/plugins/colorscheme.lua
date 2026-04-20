return {
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
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

      local function get_theme_family()
        local handle = io.open(vim.fn.expand("~/.config/theme-family"), "r")
        if not handle then
          return "tokyonight"
        end
        local family = handle:read("*l") or "tokyonight"
        handle:close()
        family = family:gsub("%s+", "")
        if family == "everforest" then
          return "everforest"
        end
        return "tokyonight"
      end

      local function colorscheme_for(family, appearance)
        if family == "everforest" then
          return appearance == "dark" and "everforest-dark" or "everforest-light"
        end
        -- tokyonight uses "night" and "day" as its variant names
        return appearance == "dark" and "tokyonight-night" or "tokyonight-day"
      end

      local appearance = get_os_appearance()
      local family = get_theme_family()
      opts.colorscheme = colorscheme_for(family, appearance)

      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          local new_appearance = get_os_appearance()
          local new_family = get_theme_family()
          if new_appearance ~= appearance or new_family ~= family then
            appearance = new_appearance
            family = new_family
            vim.cmd.colorscheme(colorscheme_for(family, appearance))
          end
        end,
      })
    end,
  },
}
