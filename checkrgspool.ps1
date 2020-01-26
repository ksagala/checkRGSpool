#
# 
#
function checkRGSpool {
    param (
        [string]$poolname
    )
    $agentgroups = Get-CsRgsAgentGroup | Where-Object OwnerPool -eq $poolname

    ForEach ($agentgr in $agentgroups) {
        $groupname = $agentgr.Name
        write-host "Processing $groupname"
        if ($agentgr.AgentsByUri.count -gt 0) {
            $agents = $agentgr.AgentsByUri
            foreach ($agent in $agents) {
                $agent = $Agent.tostring()
                # write-host "Agent $agent"

                Try {
                    $currentagent = get-csuser $agent -ErrorAction Stop
                }
                Catch [Exception] {
                    write-host "Ghost agent found: $agent" -ForegroundColor Yellow
                }
                $agentlist += $agent
            }
        }
        else {
            write-host "$groupname has no Agents" -ForegroundColor Yellow
        }
    }
}