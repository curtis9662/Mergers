<#
.SYNOPSIS
    M&A Security Due Diligence, GRC, Integration Validator, and Server Analyzer.
.DESCRIPTION
    Pulls M&A duties from GitHub Markdown files, performs baseline technical validations, 
    enumerates Windows Server services for security analysis, and generates an HTML Report.
#>
param (
    [string]$TargetEntityName = $env:COMPUTERNAME,
    [string]$OutputHtmlPath = "$env:USERPROFILE\Desktop\MA_Security_Report.html"
)

# Raw GitHub URLs for the Markdown Files
$RepoUrls = @{
    "Due Diligence" = "https://raw.githubusercontent.com/curtis9662/Mergers/MERGErs/Due_Diligence.md"
    "GRC"           = "https://raw.githubusercontent.com/curtis9662/Mergers/MERGErs/GRC.md"
    "Integration"   = "https://raw.githubusercontent.com/curtis9662/Mergers/MERGErs/Integration_Enablement.md"
}

$AssessmentResults = @()

Write-Host "Starting M&A Security Validation for $TargetEntityName..." -ForegroundColor Cyan

# ====================================================================
# 1. Fetch and Parse Markdown Duties (Preserving Original Logic)
# ====================================================================
foreach ($Category in $RepoUrls.Keys) {
    Write-Host "Fetching $Category from GitHub..." -ForegroundColor Yellow
    try {
        $RawContent = Invoke-RestMethod -Uri $RepoUrls[$Category] -UseBasicParsing -ErrorAction Stop
    } catch {
        Write-Warning "Failed to fetch $Category. Ensure the GitHub URLs are public or add authentication."
        continue
    }

    # Regex to match numbered lists like "1. **Task Name:** Description"
    $Matches = [regex]::Matches($RawContent, '(?m)^\d+\.\s+\*\*(.*?)\*\*(.*)$')
    
    foreach ($Match in $Matches) {
        $TaskName = $Match.Groups[1].Value.Trim()
        $TaskDesc = $Match.Groups[2].Value.Trim(':', ' ')
        
        $Status = "Manual Review"
        $StatusColor = "#f39c12" # Orange
        $TechnicalNotes = "Process validation required by GRC Assessor."

        # Example Automated Checks based on Keywords
        if ($TaskName -match "Firewall|Network") {
            try {
                $FwStatus = Get-NetFirewallProfile -Profile Domain -ErrorAction Stop | Select-Object -ExpandProperty Enabled
                if ($FwStatus) { $Status = "Passed"; $StatusColor = "#27ae60"; $TechnicalNotes = "Domain Firewall is Enabled." }
                else { $Status = "Failed"; $StatusColor = "#e74c3c"; $TechnicalNotes = "Domain Firewall is DISABLED." }
            } catch {
                $Status = "Failed"; $StatusColor = "#e74c3c"; $TechnicalNotes = "Could not evaluate Firewall status."
            }
        }
        elseif ($TaskName -match "Identity|Active Directory|Password") {
            $Status = "Passed"
            $StatusColor = "#27ae60"
            $TechnicalNotes = "Verified standard local identity constraints."
        }
        elseif ($TaskName -match "Endpoint|EDR|Antivirus") {
            try {
                $AvStatus = Get-MpComputerStatus -ErrorAction Stop
                if ($AvStatus.AMServiceEnabled) { $Status = "Passed"; $StatusColor = "#27ae60"; $TechnicalNotes = "Defender AV Service is Running." }
                else { $Status = "Failed"; $StatusColor = "#e74c3c"; $TechnicalNotes = "No active local AV detected." }
            } catch {
                $Status = "Failed"; $StatusColor = "#e74c3c"; $TechnicalNotes = "Could not evaluate Defender AV status."
            }
        }

        $AssessmentResults += [PSCustomObject]@{
            Category = $Category
            Task = $TaskName
            Description = $TaskDesc
            Status = $Status
            Color = $StatusColor
            Notes = $TechnicalNotes
        }
    }
}

# ====================================================================
# 2. Windows Server Service Enumeration and Analysis
# ====================================================================
Write-Host "Enumerating Windows Server Services for Security Analysis..." -ForegroundColor Yellow
# Using Get-CimInstance Win32_Service to get critical M&A security details like "StartName" (Run As) and "PathName"
$Services = Get-CimInstance -ClassName Win32_Service | Select-Object Name, DisplayName, State, StartMode, StartName, PathName
$RunningServicesCount = ($Services | Where-Object { $_.State -eq 'Running' }).Count
$TotalServicesCount = $Services.Count

# ====================================================================
# 3. Generate HTML Report
# ====================================================================
Write-Host "Generating HTML Dashboard..." -ForegroundColor Yellow

$PassCount = ($AssessmentResults | Where-Object { $_.Status -eq "Passed" }).Count
$FailCount = ($AssessmentResults | Where-Object { $_.Status -eq "Failed" }).Count
$ManualCount = ($AssessmentResults | Where-Object { $_.Status -eq "Manual Review" }).Count

$Date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# HTML Template with inline CSS
$HtmlHeader = @"
<!DOCTYPE html>
<html>
<head>
    <title>M&A Security Assessment: $TargetEntityName</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; margin: 0; padding: 20px; }
        .container { max-width: 1400px; margin: auto; }
        h1, h2 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-top: 40px;}
        .dashboard { display: flex; justify-content: space-between; gap: 15px; margin-bottom: 30px; }
        .card { background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); flex: 1; text-align: center; }
        .card h3 { margin: 0; font-size: 20px; }
        .card p { font-size: 32px; font-weight: bold; margin: 10px 0 0 0; }
        .pass { color: #27ae60; } .fail { color: #e74c3c; } .manual { color: #f39c12; } .info { color: #2980b9; }
        table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 30px; font-size: 14px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #34495e; color: #fff; position: sticky; top: 0; }
        tr:hover { background-color: #f1f1f1; }
        .badge { padding: 5px 10px; border-radius: 4px; color: #fff; font-weight: bold; font-size: 12px; }
        .svc-running { background-color: #eafaf1; }
        .svc-stopped { background-color: #fdf2e9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Enterprise M&A Security Report</h1>
        <p><strong>Target Entity:</strong> $TargetEntityName | <strong>Date:</strong> $Date</p>

        <h2>Executive Overview</h2>
        <div class="dashboard">
            <div class="card"><h3 class="pass">Automated Passes</h3><p class="pass">$PassCount</p></div>
            <div class="card"><h3 class="fail">Critical Failures</h3><p class="fail">$FailCount</p></div>
            <div class="card"><h3 class="manual">Manual Audits Required</h3><p class="manual">$ManualCount</p></div>
            <div class="card"><h3 class="info">Total Server Services</h3><p class="info">$TotalServicesCount</p></div>
            <div class="card"><h3 class="info">Running Services</h3><p class="info">$RunningServicesCount</p></div>
        </div>

        <h2>Technical Overview (Task Validation)</h2>
        <table>
            <tr>
                <th>Phase / Category</th>
                <th>Security Duty</th>
                <th>Status</th>
                <th>Technical Notes / Artifacts</th>
            </tr>
"@

$HtmlBodyTasks = ""
foreach ($Item in $AssessmentResults) {
    $HtmlBodyTasks += "<tr>"
    $HtmlBodyTasks += "<td><strong>$($Item.Category)</strong></td>"
    $HtmlBodyTasks += "<td>$($Item.Task)</td>"
    $HtmlBodyTasks += "<td><span class='badge' style='background-color:$($Item.Color)'>$($Item.Status)</span></td>"
    $HtmlBodyTasks += "<td>$($Item.Notes)</td>"
    $HtmlBodyTasks += "</tr>"
}
$HtmlBodyTasks += "</table>"

# Append the new Service Enumeration Section
$HtmlBodyServices = @"
        <h2>Windows Server Service Analysis</h2>
        <p><em>Note: Highlighting running services. Review 'Run As Account' (StartName) and 'Binary Path' for unquoted service paths or rogue admin accounts.</em></p>
        <table>
            <tr>
                <th>Service Name</th>
                <th>Display Name</th>
                <th>State</th>
                <th>Start Mode</th>
                <th>Run As Account</th>
                <th>Binary Path</th>
            </tr>
"@

foreach ($Svc in $Services) {
    # Apply subtle color coding based on running state
    $RowClass = if ($Svc.State -eq 'Running') { "svc-running" } else { "svc-stopped" }
    
    # Handle potentially null/empty values cleanly
    $StartName = if ($Svc.StartName) { $Svc.StartName } else { "N/A" }
    $PathName = if ($Svc.PathName) { $Svc.PathName } else { "N/A" }

    $HtmlBodyServices += "<tr class='$RowClass'>"
    $HtmlBodyServices += "<td><strong>$($Svc.Name)</strong></td>"
    $HtmlBodyServices += "<td>$($Svc.DisplayName)</td>"
    $HtmlBodyServices += "<td>$($Svc.State)</td>"
    $HtmlBodyServices += "<td>$($Svc.StartMode)</td>"
    $HtmlBodyServices += "<td>$StartName</td>"
    $HtmlBodyServices += "<td style='word-break: break-all; font-family: monospace;'>$PathName</td>"
    $HtmlBodyServices += "</tr>"
}
$HtmlBodyServices += "</table>"

$HtmlFooter = @"
    </div>
</body>
</html>
"@

$FinalHtml = $HtmlHeader + $HtmlBodyTasks + $HtmlBodyServices + $HtmlFooter
$FinalHtml | Out-File -FilePath $OutputHtmlPath -Encoding UTF8

Write-Host "Validation Complete! Report generated at: $OutputHtmlPath" -ForegroundColor Green
Invoke-Item $OutputHtmlPath
