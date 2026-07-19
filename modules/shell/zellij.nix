{
  den.aspects.shell = {
    homeManager = {pkgs, ...}: {
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.zellij = {
        enable = true;
        plugins = with pkgs.zellijPlugins; [vim-zellij-navigator];
        # Don't autostart on fish start
        enableFishIntegration = false;

        settings = {
          keybinds = {
            _props."clear-defaults" = true;
            _children = [
              {
                locked._children = [
                  {
                    bind = {
                      _args = ["Ctrl a"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                ];
              }
              {
                normal._children = [
                  {
                    bind = {
                      _args = ["x"];
                      _children = [{Detach = {};}];
                    };
                  }
                ];
              }
              {
                pane._children = [
                  {
                    bind = {
                      _args = ["left"];
                      _children = [{MoveFocus = ["left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["down"];
                      _children = [{MoveFocus = ["down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["up"];
                      _children = [{MoveFocus = ["up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["right"];
                      _children = [{MoveFocus = ["right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["h"];
                      _children = [{MoveFocus = ["left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["j"];
                      _children = [{MoveFocus = ["down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["k"];
                      _children = [{MoveFocus = ["up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["l"];
                      _children = [{MoveFocus = ["right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["r"];
                      _children = [{SwitchToMode = ["renamepane"];} {PaneNameInput = [0];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["e"];
                      _children = [{EditScrollback = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["f"];
                      _children = [{ToggleFocusFullscreen = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["i"];
                      _children = [{TogglePanePinned = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["n"];
                      _children = [{NewPane = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["p"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["t"];
                      _children = [{BreakPane = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["v"];
                      _children = [{NewPane = ["down"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["s"];
                      _children = [{NewPane = ["right"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["w"];
                      _children = [{ToggleFloatingPanes = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["x"];
                      _children = [{CloseFocus = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["z"];
                      _children = [{TogglePaneFrames = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["tab"];
                      _children = [{SwitchFocus = {};}];
                    };
                  }
                ];
              }
              {
                tab._children = [
                  {
                    bind = {
                      _args = ["left"];
                      _children = [{GoToPreviousTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["down"];
                      _children = [{GoToNextTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["up"];
                      _children = [{GoToPreviousTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["right"];
                      _children = [{GoToNextTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["1"];
                      _children = [{GoToTab = [1];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["2"];
                      _children = [{GoToTab = [2];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["3"];
                      _children = [{GoToTab = [3];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["4"];
                      _children = [{GoToTab = [4];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["5"];
                      _children = [{GoToTab = [5];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["6"];
                      _children = [{GoToTab = [6];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["7"];
                      _children = [{GoToTab = [7];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["8"];
                      _children = [{GoToTab = [8];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["9"];
                      _children = [{GoToTab = [9];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["["];
                      _children = [{BreakPaneLeft = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["]"];
                      _children = [{BreakPaneRight = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["b"];
                      _children = [{BreakPane = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["h"];
                      _children = [{GoToPreviousTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["j"];
                      _children = [{GoToNextTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["k"];
                      _children = [{GoToPreviousTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["l"];
                      _children = [{GoToNextTab = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["n"];
                      _children = [{NewTab = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["r"];
                      _children = [{SwitchToMode = ["renametab"];} {TabNameInput = [0];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["s"];
                      _children = [{ToggleActiveSyncTab = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["t"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["x"];
                      _children = [{CloseTab = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["tab"];
                      _children = [{ToggleTab = {};}];
                    };
                  }
                ];
              }
              {
                resize._children = [
                  {
                    bind = {
                      _args = ["left"];
                      _children = [{Resize = ["Increase left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["down"];
                      _children = [{Resize = ["Increase down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["up"];
                      _children = [{Resize = ["Increase up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["right"];
                      _children = [{Resize = ["Increase right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["+"];
                      _children = [{Resize = ["Increase"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["-"];
                      _children = [{Resize = ["Decrease"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["="];
                      _children = [{Resize = ["Increase"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["H"];
                      _children = [{Resize = ["Decrease left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["J"];
                      _children = [{Resize = ["Decrease down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["K"];
                      _children = [{Resize = ["Decrease up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["L"];
                      _children = [{Resize = ["Decrease right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["h"];
                      _children = [{Resize = ["Increase left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["j"];
                      _children = [{Resize = ["Increase down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["k"];
                      _children = [{Resize = ["Increase up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["l"];
                      _children = [{Resize = ["Increase right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["r"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                ];
              }
              {
                move._children = [
                  {
                    bind = {
                      _args = ["left"];
                      _children = [{MovePane = ["left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["down"];
                      _children = [{MovePane = ["down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["up"];
                      _children = [{MovePane = ["up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["right"];
                      _children = [{MovePane = ["right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["h"];
                      _children = [{MovePane = ["left"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["j"];
                      _children = [{MovePane = ["down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["k"];
                      _children = [{MovePane = ["up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["l"];
                      _children = [{MovePane = ["right"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["m"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["n"];
                      _children = [{MovePane = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["p"];
                      _children = [{MovePaneBackwards = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["tab"];
                      _children = [{MovePane = {};}];
                    };
                  }
                ];
              }
              {
                scroll._children = [
                  {
                    bind = {
                      _args = ["Alt left"];
                      _children = [{MoveFocusOrTab = ["left"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt down"];
                      _children = [{MoveFocus = ["down"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt up"];
                      _children = [{MoveFocus = ["up"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt right"];
                      _children = [{MoveFocusOrTab = ["right"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["e"];
                      _children = [{EditScrollback = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["f"];
                      _children = [{SwitchToMode = ["entersearch"];} {SearchInput = [0];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt h"];
                      _children = [{MoveFocusOrTab = ["left"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt j"];
                      _children = [{MoveFocus = ["down"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt k"];
                      _children = [{MoveFocus = ["up"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["Alt l"];
                      _children = [{MoveFocusOrTab = ["right"];} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["s"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                ];
              }
              {
                search._children = [
                  {
                    bind = {
                      _args = ["y"];
                      _children = [{Copy = {};} {SwitchToMode = ["locked"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["c"];
                      _children = [{SearchToggleOption = ["CaseSensitivity"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["n"];
                      _children = [{Search = ["down"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["o"];
                      _children = [{SearchToggleOption = ["WholeWord"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["p"];
                      _children = [{Search = ["up"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["w"];
                      _children = [{SearchToggleOption = ["Wrap"];}];
                    };
                  }
                ];
              }
              {
                session._children = [
                  {
                    bind = {
                      _args = ["a"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["zellij:about"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                  {
                    bind = {
                      _args = ["c"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["configuration"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                  {
                    bind = {
                      _args = ["d"];
                      _children = [{Detach = {};}];
                    };
                  }
                  {
                    bind = {
                      _args = ["l"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["zellij:layout-manager"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                  {
                    bind = {
                      _args = ["o"];
                      _children = [{SwitchToMode = ["normal"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["p"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["plugin-manager"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                  {
                    bind = {
                      _args = ["s"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["zellij:share"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                  {
                    bind = {
                      _args = ["w"];
                      _children = [
                        {
                          LaunchOrFocusPlugin = {
                            _args = ["session-manager"];
                            _children = [{floating = true;} {move_to_focused_tab = true;}];
                          };
                        }
                        {SwitchToMode = ["locked"];}
                      ];
                    };
                  }
                ];
              }
              {
                shared_among = {
                  _args = ["normal" "locked"];
                  _children = [
                    {
                      bind = {
                        _args = ["Alt left"];
                        _children = [{MoveFocusOrTab = ["left"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt down"];
                        _children = [{MoveFocus = ["down"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt up"];
                        _children = [{MoveFocus = ["up"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt right"];
                        _children = [{MoveFocusOrTab = ["right"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl h"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["navigator"];
                              _children = [{name = ["move_focus"];} {payload = ["left"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl j"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["navigator"];
                              _children = [{name = ["move_focus"];} {payload = ["down"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl k"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["navigator"];
                              _children = [{name = ["move_focus"];} {payload = ["up"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl l"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["navigator"];
                              _children = [{name = ["move_focus"];} {payload = ["right"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl Alt h"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm"];
                              _children = [{name = ["resize"];} {payload = ["left"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl Alt j"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm"];
                              _children = [{name = ["resize"];} {payload = ["down"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl Alt k"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm"];
                              _children = [{name = ["resize"];} {payload = ["up"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl Alt l"];
                        _children = [
                          {
                            MessagePlugin = {
                              _args = ["https://github.com/hiasr/vim-zellij-navigator/releases/download/0.3.0/vim-zellij-navigator.wasm"];
                              _children = [{name = ["resize"];} {payload = ["right"];}];
                            };
                          }
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt +"];
                        _children = [{Resize = ["Increase"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt -"];
                        _children = [{Resize = ["Decrease"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt ="];
                        _children = [{Resize = ["Increase"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt ["];
                        _children = [{PreviousSwapLayout = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt ]"];
                        _children = [{NextSwapLayout = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt t"];
                        _children = [{NewTab = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 1"];
                        _children = [{GoToTab = [1];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 2"];
                        _children = [{GoToTab = [2];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 3"];
                        _children = [{GoToTab = [3];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 4"];
                        _children = [{GoToTab = [4];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 5"];
                        _children = [{GoToTab = [5];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 6"];
                        _children = [{GoToTab = [6];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 7"];
                        _children = [{GoToTab = [7];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 8"];
                        _children = [{GoToTab = [8];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt 9"];
                        _children = [{GoToTab = [9];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt e"];
                        _children = [{EditScrollback = {};} {SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt v"];
                        _children = [{NewPane = ["down"];} {SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt s"];
                        _children = [{NewPane = ["right"];} {SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt /"];
                        _children = [{SwitchToMode = ["entersearch"];} {SearchInput = [0];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt f"];
                        _children = [{ToggleFloatingPanes = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt h"];
                        _children = [{GoToPreviousTab = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt l"];
                        _children = [{GoToNextTab = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt i"];
                        _children = [{MoveTab = ["left"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt o"];
                        _children = [{MoveTab = ["right"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt n"];
                        _children = [{NewPane = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt x"];
                        _children = [{CloseFocus = {};} {SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt p"];
                        _children = [{TogglePaneInGroup = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt Shift p"];
                        _children = [{ToggleGroupMarking = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["PageUp"];
                        _children = [{HalfPageScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["PageDown"];
                        _children = [{HalfPageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt a"];
                        _children = [
                          {
                            Run = {
                              _args = ["tuxedo"];
                              _children = [{floating = true;} {width = ["80%"];} {height = ["80%"];} {close_on_exit = true;}];
                            };
                          }
                          {SwitchToMode = ["locked"];}
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt r"];
                        _children = [
                          {
                            Run = {
                              _args = ["tv" "zellij"];
                              _children = [{floating = true;} {width = ["60%"];} {height = ["80%"];} {close_on_exit = true;}];
                            };
                          }
                          {SwitchToMode = ["locked"];}
                        ];
                      };
                    }
                    {
                      bind = {
                        _args = ["Alt w"];
                        _children = [
                          {
                            LaunchOrFocusPlugin = {
                              _args = ["session-manager"];
                              _children = [{floating = true;} {move_to_focused_tab = true;}];
                            };
                          }
                          {SwitchToMode = ["locked"];}
                        ];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "renametab" "renamepane"];
                  _children = [
                    {
                      bind = {
                        _args = ["Ctrl g"];
                        _children = [{SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl q"];
                        _children = [{Quit = {};}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "entersearch"];
                  _children = [
                    {
                      bind = {
                        _args = ["enter"];
                        _children = [{SwitchToMode = ["locked"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "entersearch" "renametab" "renamepane"];
                  _children = [
                    {
                      bind = {
                        _args = ["esc"];
                        _children = [{SwitchToMode = ["locked"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "entersearch" "renametab" "renamepane" "move"];
                  _children = [
                    {
                      bind = {
                        _args = ["m"];
                        _children = [{SwitchToMode = ["move"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "entersearch" "search" "renametab" "renamepane" "session"];
                  _children = [
                    {
                      bind = {
                        _args = ["o"];
                        _children = [{SwitchToMode = ["session"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "tab" "entersearch" "renametab" "renamepane"];
                  _children = [
                    {
                      bind = {
                        _args = ["t"];
                        _children = [{SwitchToMode = ["tab"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_among = {
                  _args = ["normal" "resize" "tab" "scroll" "prompt" "tmux"];
                  _children = [
                    {
                      bind = {
                        _args = ["p"];
                        _children = [{SwitchToMode = ["pane"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_among = {
                  _args = ["normal" "resize" "search" "move" "prompt" "tmux"];
                  _children = [
                    {
                      bind = {
                        _args = ["s"];
                        _children = [{SwitchToMode = ["scroll"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_except = {
                  _args = ["locked" "resize" "pane" "tab" "entersearch" "renametab" "renamepane"];
                  _children = [
                    {
                      bind = {
                        _args = ["r"];
                        _children = [{SwitchToMode = ["resize"];}];
                      };
                    }
                  ];
                };
              }
              {
                shared_among = {
                  _args = ["scroll" "search"];
                  _children = [
                    {
                      bind = {
                        _args = ["PageDown"];
                        _children = [{PageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["PageUp"];
                        _children = [{PageScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["left"];
                        _children = [{PageScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["down"];
                        _children = [{ScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["up"];
                        _children = [{ScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["right"];
                        _children = [{PageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl b"];
                        _children = [{PageScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl c"];
                        _children = [{ScrollToBottom = {};} {SwitchToMode = ["locked"];}];
                      };
                    }
                    {
                      bind = {
                        _args = ["d"];
                        _children = [{HalfPageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["Ctrl f"];
                        _children = [{PageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["h"];
                        _children = [{PageScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["j"];
                        _children = [{ScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["k"];
                        _children = [{ScrollUp = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["l"];
                        _children = [{PageScrollDown = {};}];
                      };
                    }
                    {
                      bind = {
                        _args = ["u"];
                        _children = [{HalfPageScrollUp = {};}];
                      };
                    }
                  ];
                };
              }
              {
                entersearch._children = [
                  {
                    bind = {
                      _args = ["Ctrl c"];
                      _children = [{SwitchToMode = ["scroll"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["esc"];
                      _children = [{SwitchToMode = ["scroll"];}];
                    };
                  }
                  {
                    bind = {
                      _args = ["enter"];
                      _children = [{SwitchToMode = ["search"];}];
                    };
                  }
                ];
              }
              {
                renametab._children = [
                  {
                    bind = {
                      _args = ["esc"];
                      _children = [{UndoRenameTab = {};} {SwitchToMode = ["tab"];}];
                    };
                  }
                ];
              }
              {
                shared_among = {
                  _args = ["renametab" "renamepane"];
                  _children = [
                    {
                      bind = {
                        _args = ["Ctrl c"];
                        _children = [{SwitchToMode = ["locked"];}];
                      };
                    }
                  ];
                };
              }
              {
                renamepane._children = [
                  {
                    bind = {
                      _args = ["esc"];
                      _children = [{UndoRenamePane = {};} {SwitchToMode = ["pane"];}];
                    };
                  }
                ];
              }
            ];
          };

          plugins = {
            about._props.location = "zellij:about";
            "compact-bar"._props.location = "zellij:compact-bar";
            configuration._props.location = "zellij:configuration";
            filepicker = {
              _props.location = "zellij:strider";
              cwd = ["/"];
            };
            "plugin-manager"._props.location = "zellij:plugin-manager";
            "session-manager"._props.location = "zellij:session-manager";
            "status-bar"._props.location = "zellij:status-bar";
            strider._props.location = "zellij:strider";
            "tab-bar"._props.location = "zellij:tab-bar";
            "welcome-screen" = {
              _props.location = "zellij:session-manager";
              welcome_screen = true;
            };
            navigator._props.location = "file:$HOME/.config/zellij/plugins/vim-zellij-navigator.wasm";
          };

          load_plugins = {
            "zellij:link" = {};
            navigator.grant_permissions = true;
          };

          web_client.font = "GeistMono Nerd Font Mono";
          simplified_ui = true;
          theme = "catppuccin-mocha";
          default_mode = "locked";
          pane_frames = false;
          copy_on_select = false;
          scrollback_editor = "nvim";
          support_kitty_keyboard_protocol = true;
          show_startup_tips = false;

          ui.pane_frames.hide_session_name = false;
        };
      };
    };
  };
}
