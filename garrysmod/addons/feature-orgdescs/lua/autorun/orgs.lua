simpleOrgs = simpleOrgs or {}
octolib.shared('config/groups')

octolib.client('orgs/client')

octolib.server('orgs/server')
octolib.server('orgs/ext_player_sv')

octolib.client('orgs/cl_multirank')
octolib.shared('orgs/ext_player_sh')
octolib.server('orgs/sv_multirank')
