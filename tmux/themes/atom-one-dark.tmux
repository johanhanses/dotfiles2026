# Atom One Dark — catppuccin-style segmented status with rounded powerline caps.
# Requires a Nerd Font (BlexMono / GeistMono Nerd Font etc.) for the  /  glyphs.

# Palette
%hidden BG="#282c34"
%hidden FG="#abb2bf"
%hidden SURFACE="#3e4451"
%hidden MUTED="#5c6370"
%hidden BLUE="#61afef"
%hidden GREEN="#98c379"
%hidden YELLOW="#e5c07b"
%hidden RED="#e06c75"
%hidden MAGENTA="#c678dd"
%hidden CYAN="#56b6c2"

set -g status on
set -g status-position bottom
set -g status-interval 5
set -g status-justify left
set -g status-left-length 200
set -g status-right-length 200
set -g status-style "bg=${BG},fg=${FG}"

# LEFT — session: rounded blue segment
set -g status-left "#[fg=${BLUE},bg=${BG}]#[fg=${BG},bg=${BLUE},bold]  #S #[fg=${BLUE},bg=${BG},nobold]"

# Window status
set -g window-status-separator ""
set -g window-status-format          "#[fg=${SURFACE},bg=${BG}]#[fg=${MUTED},bg=${SURFACE}] #I #[fg=${FG},bg=${SURFACE}]#W #[fg=${SURFACE},bg=${BG}] "
set -g window-status-current-format  "#[fg=${YELLOW},bg=${BG}]#[fg=${BG},bg=${YELLOW},bold] #I #[fg=${BG},bg=${YELLOW}]#W #[fg=${YELLOW},bg=${BG},nobold] "

# RIGHT — time (cyan) + date (magenta), rounded segments
set -g status-right "#[fg=${CYAN},bg=${BG}]#[fg=${BG},bg=${CYAN},bold]  %H:%M #[fg=${CYAN},bg=${BG}] #[fg=${MAGENTA},bg=${BG}]#[fg=${BG},bg=${MAGENTA},bold]  %d %b #[fg=${MAGENTA},bg=${BG},nobold]"

# Pane borders
set -g pane-border-style        "fg=${SURFACE}"
set -g pane-active-border-style "fg=${BLUE}"

# Messages / command prompt
set -g message-style         "bg=${SURFACE},fg=${YELLOW},bold"
set -g message-command-style "bg=${SURFACE},fg=${CYAN},bold"

# Copy-mode selection
set -g mode-style "bg=${YELLOW},fg=${BG}"
