import XMonad
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Maximize
import XMonad.Layout.Minimize
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.StackSet hiding (workspaces)
import XMonad.Util.EZConfig
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog

-- Shell commands
cmd_browser = "chromium-browser"
cmd_lockScreen = "~/bin/lock"
cmd_volDown = "amixer set Master 1- unmute"
cmd_volUp = "amixer set Master 1+ unmute"
cmd_volMute = "amixer set Master toggle"
cmd_touchpadToggle = "touchtoggle"
cmd_gmrun = "gmrun"
cmd_lockSuspend = cmd_lockScreen

-- Key codes
keyCode_volDown = 0x1008ff11
keyCode_volUp = 0x1008ff13
keyCode_volMute = 0x1008ff12
keyCode_suspend = 0x1008ffa7

-- Color definitions
colorDef_white = "#ffffff"
colorDef_darkGray = "#888888"
colorDef_midGray = "#111111"
colorDef_green = "00ff00"
colorDef_red = "ff0000"
                   
-- Color assignments
color_focusedBorder = colorDef_green
color_normalBorder = colorDef_red

-- Additional workspaces & associated hotkeys
addWorkspaces = [("0", xK_0)]

-- List of X11 window classes which should never steal focus
noStealFocusWins = ["Pidgin"]

-- Misc constants
my_terminal = "xfce4-terminal"
my_modKey = mod4Mask
-- xmproc = spawnPipe "xmobar /home/sdqali/.xmobarrc"


-- General configuration
myConfig = withUrgencyHook NoUrgencyHook defaultConfig
    { terminal = my_terminal
    , modMask = my_modKey
    , focusedBorderColor = color_focusedBorder
    , normalBorderColor = color_normalBorder
--    , logHook = dynamicLogWithPP xmobarPP
--                                       { ppOutput = hPutStrLn xmproc
--                                       , ppTitle = xmobarColor "green" "" . shorten 50
--                                      }
    , manageHook = floatNextHook
               <+> manageDocks
               <+> (isFullscreen --> doFullFloat)
               <+> composeAll
                    [className =? c --> doF focusDown | c <- noStealFocusWins]
               <+> manageHook defaultConfig
    , layoutHook = configurableNavigation noNavigateBorders $ smartBorders $
        avoidStruts myLayouts
    , workspaces = map show [1 .. 9 :: Int] ++ map fst addWorkspaces
    } `additionalKeys` myKeys

-- Custom key bindings
myKeys = [ ((my_modKey .|. shiftMask, xK_l), spawn cmd_lockScreen)
         , ((0, keyCode_volDown), spawn cmd_volDown)
         , ((0, keyCode_volUp), spawn cmd_volUp)
         , ((0, keyCode_volMute), spawn cmd_volMute)
         , ((0, keyCode_suspend), spawn cmd_lockSuspend)
         , ((my_modKey, xK_i), withFocused $ sendMessage . MinimizeWin)
         , ( (my_modKey .|. shiftMask, xK_i)
           , sendMessage RestoreNextMinimizedWin
           )
         , ( (my_modKey .|. controlMask, xK_i)
           , withFocused $ sendMessage . RestoreMinimizedWin
           )
         , ( (my_modKey, xK_backslash)
           , withFocused (sendMessage . maximizeRestore)
           )
         , ((my_modKey, xK_Up), sendMessage $ Go U)
         , ((my_modKey, xK_Down), sendMessage $ Go D)
         , ((my_modKey, xK_Left), sendMessage $ Go L)
         , ((my_modKey, xK_Right), sendMessage $ Go R)
         , ((my_modKey .|. mod1Mask, xK_Left), prevWS)
         , ((my_modKey .|. mod1Mask, xK_Right), nextWS)
         , ((my_modKey .|. shiftMask, xK_Up), sendMessage $ Swap U)
         , ((my_modKey .|. shiftMask, xK_Down), sendMessage $ Swap D)
         , ((my_modKey .|. shiftMask, xK_Left), sendMessage $ Swap L)
         , ((my_modKey .|. shiftMask, xK_Right), sendMessage $ Swap R)
         , ((my_modKey, xK_g), goToSelected defaultGSConfig)
         , ((my_modKey .|. shiftMask, xK_b), spawn cmd_browser)
         , ((my_modKey .|. shiftMask, xK_p), spawn cmd_gmrun)
         , ((my_modKey, xK_f), toggleFloatNext)
         , ((my_modKey, xK_d), toggleFloatAllNew)
         , ((my_modKey, xK_F12), spawn cmd_touchpadToggle)
         ] ++
         [((my_modKey .|. m, k), windows $ f ws)
            | (m, f) <- [(0, greedyView), (shiftMask, shift)]
            , (ws, k) <- addWorkspaces]


-- Status bar configuration
myStatusBar = statusBar ("dzen2 " ++ flags) dzenPP' $ const (my_modKey, xK_b)
    where fg = "white"  -- Default: #a8a3f7
          bg = "black"  -- Default: #3f3c6d
          flags = "-e 'onstart=lower' -w 1055 -ta l -fg "
               ++ fg
               ++ " -bg "
               ++ bg
               ++ " -fn '-*-profont-*-*-*-*-11-*-*-*-*-*-*-*'"
          dzenPP' = let lt = colorDef_white
                        md = colorDef_darkGray
                        dk = "black"
                    in defaultPP
                        { ppCurrent = dzenColor dk lt . pad
                        , ppVisible = dzenColor dk md . pad
                        , ppHidden = dzenColor lt dk . pad
                        , ppHiddenNoWindows = const ""
                        , ppUrgent = dzenColor "blue" "red" . dzenStrip
                        , ppWsSep = ""
                        , ppSep = ""
                        , ppLayout = dzenColor dk md . \x -> pad $ case x of
                            "Maximize Tall" -> "MXT"
                            "Tabbed Simplest" -> "TAB"
                            _ -> x
                        , ppTitle = dzenColor lt dk . pad . dzenEscape
                        }

-- Workspace layouts
myLayouts = (maximize $ Tall 1 (3/100) (1/2))
        ||| simpleTabbed

main = xmonad =<< xmobar =<< myStatusBar myConfig