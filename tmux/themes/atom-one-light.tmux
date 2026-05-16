# Atom One Light — catppuccin-style segmented status with rounded powerline caps.
# Requires a Nerd Font (BlexMono / GeistMono Nerd Font etc.) for the  /  glyphs.

# Palette
%hidden BG="#fafafa"
%hidden FG="#383a42"
%hidden SURFACE="#e5e5e6"
%hidden MUTED="#696c77"
%hidden BLUE="#4078f2"
%hidden GREEN="#50a14f"
%hidden YELLOW="#c18401"
%hidden RED="#e45649"
%hidden MAGENTA="#a626a4"
%hidden CYAN="#0184bc"
%hidden ON_ACCENT="#fafafa"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

# LEFT — session: rounded blue segment
set -g status-left "#[fg=${BLUE},bg=${BG}]#[fg=${ON_ACCENT},bg=${BLUE},bold]  #S #[fg=${BLUE},bg=${BG},nobold]"

# Window status — inactive: subtle surface chip; active: yellow rounded segment
set -g window-status-separator ""
set -g window-status-format          "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}]  "
set -g window-status-current-format  "#[fg=${YELLOW},bg=${BG}]#[fg=${ON_ACCENT},bg=${YELLOW},bold] #I #[fg=${ON_ACCENT},bg=${YELLOW}]#W #[fg=${YELLOW},bg=${BG},nobold]  "

# RIGHT — time (cyan) + date (magenta), rounded segments
set -g status-right "#[fg=${CYAN},bg=${BG}]#[fg=${ON_ACCENT},bg=${CYAN},bold]  %H:%M #[fg=${ON_ACCENT},bg=${CYAN}]#[fg=${ON_ACCENT},bg=${MAGENTA},bold] #[fg=${ON_ACCENT},bg=${MAGENTA}]  %d %b #[fg=${MAGENTA},bg=${BG},nobold]"

# Pane borders
set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${BLUE}"

# Messages / command prompt
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"

# Copy-mode selection
set -g mode-style "bg=${YELLOW},fg=${ON_ACCENT}"
