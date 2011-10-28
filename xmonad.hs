import XMonad
import XMonad.Actions.GridSelect
import XMonad.Util.Run
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

-- Additional workspaces & associated hotkeys
addWorkspaces = [("0", xK_0)]

-- List of X11 window classes which should never steal focus
noStealFocusWins = ["Pidgin"]

-- Misc constants
my_terminal = "xfce4-terminal"
my_modKey = mod4Mask


-- General configuration
myConfig = withUrgencyHook NoUrgencyHook defaultConfig
    { terminal = my_terminal
    , modMask = my_modKey
    , focusedBorderColor = "red"
    , normalBorderColor = "gray"
    , borderWidth = 3
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
         , ((my_modKey .|. controlMask, xK_Left), shiftToPrev)
         , ((my_modKey .|. controlMask, xK_Right), shiftToNext)
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


-- Workspace layouts
myLayouts = (maximize $ Tall 1 (3/100) (1/2))
        ||| simpleTabbed

main = do
  h <- spawnPipe "xmobar /home/sdqali/.xmobarrc"
  xmonad =<< xmobar myConfig {
    logHook = dynamicLogWithPP $ xmobarPP
                                      { ppOutput = hPutStrLn h
                                      , ppTitle = xmobarColor "green" "" . shorten 50
                                      }
    }
