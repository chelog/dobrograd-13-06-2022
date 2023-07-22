octogui = octogui or {}

octolib.client('config/octogui/f4')
octolib.client('config/octogui/score')

octolib.client('octogui/esc')
octolib.client('octogui/f4')
octolib.client('octogui/circular')
octolib.client('octogui/notifications')

-- include client first to create functions used in shared
octolib.client('octogui/cmenu/client')
octolib.shared('octogui/cmenu/shared')
