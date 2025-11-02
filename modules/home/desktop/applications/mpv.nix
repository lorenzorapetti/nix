{config, ...}: let
  fonts = config.stylix.fonts;
  colors = config.lib.stylix.colors.withHashtag;
in {
  programs.mpv = {
    enable = true;
    config = {
      osc = "no";
    };
    scriptOpts = {
      modernz = let
        textColor = colors.base05;
        accentColor = colors.base07;
      in {
        font = fonts.sansSerif.name;
        # Colors and style
        # accent color of the OSC and title bar
        osc_color = colors.base00;
        # color of the title in borderless/fullscreen mode
        window_title_color = textColor;
        # color of the window controls (close, minimize, maximize) in borderless/fullscreen mode
        window_controls_color = textColor;
        # color of close window control on hover
        windowcontrols_close_hover = accentColor;
        # color of maximize window controls on hover
        windowcontrols_max_hover = accentColor;
        # color of minimize window controls on hover
        windowcontrols_min_hover = accentColor;
        # color of the title (above seekbar)
        title_color = textColor;
        # color of the cache information
        cache_info_color = textColor;
        # color of the seekbar progress and handle
        seekbarfg_color = accentColor;
        # color of the remaining seekbar
        seekbarbg_color = colors.base02;
        # color of the cache ranges on the seekbar
        seekbar_cache_color = colors.base03;
        # match volume bar color with seekbar color (ignores side_buttons_color)
        volumebar_match_seek_color = "no";
        # color of the timestamps (below seekbar)
        time_color = textColor;
        # color of the chapter title next to timestamp (below seekbar)
        chapter_title_color = textColor;
        # color of the side buttons (audio, subtitles, playlist, etc.)
        side_buttons_color = textColor;
        # color of the middle buttons (skip, jump, chapter, etc.)
        middle_buttons_color = textColor;
        # color of the play/pause button
        playpause_color = textColor;
        # color of the element when held down (pressed)
        held_element_color = colors.base04;
        # color of a hovered button when hover_effect includes "color"
        hover_effect_color = accentColor;
        # color of the border for thumbnails (with thumbfast)
        thumbnail_border_color = colors.base00;
        # color of the border outline for thumbnails
        thumbnail_border_outline = colors.base02;
      };
    };
  };
}
