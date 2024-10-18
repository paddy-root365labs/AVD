# Important: change the value of profilesPath in line 52

# Define the log file path
$logFilePath = "C:\logs\RegistryScriptLog.txt"

# Ensure the logs folder exists
if (-not (Test-Path "C:\logs")) {
    New-Item -Path "C:\" -Name "logs" -ItemType Directory -Force
}

# Function to log messages
function LogMessage {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFilePath -Append
}

# Define the registry paths
$fslogixPath = "HKLM:\Software\FSLogix"
$profilesPath = "$fslogixPath\Profiles"
$kerberosParamsPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters"
$azureADAccountPath = "HKLM:\Software\Policies\Microsoft\AzureADAccount"

# Create the FSLogix key if it doesn't exist
if (-not (Test-Path $fslogixPath)) {
    try {
        New-Item -Path "HKLM:\Software" -Name "FSLogix" -Force
        LogMessage "FSLogix key created."
    } catch {
        LogMessage "Failed to create FSLogix key: $_"
    }
} else {
    LogMessage "FSLogix key already exists."
}

# Create the Profiles key under FSLogix if it doesn't exist
if (-not (Test-Path $profilesPath)) {
    try {
        New-Item -Path $fslogixPath -Name "Profiles" -Force
        LogMessage "Profiles key created under FSLogix."
    } catch {
        LogMessage "Failed to create Profiles key: $_"
    }
} else {
    LogMessage "Profiles key already exists under FSLogix."
}

# Set the multi-string value VHDLocations
if (-not (Get-ItemProperty -Path $profilesPath -Name "VHDLocations" -ErrorAction SilentlyContinue)) {
    try {
        new-ItemProperty -Path $profilesPath -Name "VHDLocations" -Value "xxxxxx" -PropertyType MultiString
        LogMessage "VHDLocations multi-string value set."
    } catch {
        LogMessage "Failed to set VHDLocations value: $_"
    }
} else {
    LogMessage "VHDLocations multi-string value already exists."
}

# Set the string value VolumeType
if (-not (Get-ItemProperty -Path $profilesPath -Name "VolumeType" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $profilesPath -Name "VolumeType" -Value "vhdx" -PropertyType String
        LogMessage "VolumeType string value set."
    } catch {
        LogMessage "Failed to set VolumeType value: $_"
    }
} else {
    LogMessage "VolumeType string value already exists."
}

# Set the Dword value Enabled
if (-not (Get-ItemProperty -Path $profilesPath -Name "Enabled" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $profilesPath -Name "Enabled" -Value 1 -PropertyType DWord
        LogMessage "Enabled Dword value set."
    } catch {
        LogMessage "Failed to set Enabled value: $_"
    }
} else {
    LogMessage "Enabled DWord value already exists."
}

# Set the Dword value DeleteLocalProfileWhenVHDShouldApply
if (-not (Get-ItemProperty -Path $profilesPath -Name "DeleteLocalProfileWhenVHDShouldApply" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $profilesPath -Name "DeleteLocalProfileWhenVHDShouldApply" -Value 1 -PropertyType DWord
        LogMessage "DeleteLocalProfileWhenVHDShouldApply Dword value set."
    } catch {
        LogMessage "Failed to set DeleteLocalProfileWhenVHDShouldApply value: $_"
    }
} else {
    LogMessage "DeleteLocalProfileWhenVHDShouldApply DWord value already exists."
}


# Set the Dword value FlipFlopProfileDirectoryName
if (-not (Get-ItemProperty -Path $profilesPath -Name "FlipFlopProfileDirectoryName" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $profilesPath -Name "FlipFlopProfileDirectoryName" -Value 1 -PropertyType DWord
        LogMessage "FlipFlopProfileDirectoryName Dword value set."
    } catch {
        LogMessage "Failed to set FlipFlopProfileDirectoryName value: $_"
    }
} else {
    LogMessage "FlipFlopProfileDirectoryName DWord value already exists."
}

# Create the Parameters key if it doesn't exist under Kerberos path
if (-not (Test-Path $kerberosParamsPath)) {
    try {
        New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos" -Name "Parameters" -Force
        LogMessage "Kerberos Parameters key created."
    } catch {
        LogMessage "Failed to create Kerberos Parameters key: $_"
    }
} else {
    LogMessage "Kerberos Parameters key already exists."
}

# Set the DWORD value CloudKerberosTicketRetrievalEnabled to 1
if (-not (Get-ItemProperty -Path $kerberosParamsPath -Name "CloudKerberosTicketRetrievalEnabled" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $kerberosParamsPath -Name "CloudKerberosTicketRetrievalEnabled" -Value 1 -PropertyType DWord
        LogMessage "CloudKerberosTicketRetrievalEnabled DWORD value set to 1."
    } catch {
        LogMessage "Failed to set CloudKerberosTicketRetrievalEnabled value: $_"
    }
} else {
    LogMessage "CloudKerberosTicketRetrievalEnabled DWORD value already exists."
}

# Create the AzureADAccount key under Policies\Microsoft if it doesn't exist
if (-not (Test-Path $azureADAccountPath)) {
    try {
        New-Item -Path "HKLM:\Software\Policies\Microsoft" -Name "AzureADAccount" -Force
        LogMessage "AzureADAccount key created under Policies\Microsoft."
    } catch {
        LogMessage "Failed to create AzureADAccount key: $_"
    }
} else {
    LogMessage "AzureADAccount key already exists under Policies\Microsoft."
}

# Set the DWORD value LoadCredKeyFromProfile to 1
if (-not (Get-ItemProperty -Path $azureADAccountPath -Name "LoadCredKeyFromProfile" -ErrorAction SilentlyContinue)) {
    try {
        New-ItemProperty -Path $azureADAccountPath -Name "LoadCredKeyFromProfile" -Value 1 -PropertyType DWord
        LogMessage "LoadCredKeyFromProfile DWORD value set to 1."
    } catch {
        LogMessage "Failed to set LoadCredKeyFromProfile value: $_"
    }
} else {
    LogMessage "LoadCredKeyFromProfile DWORD value already exists."
}

Write-Host "Script execution complete. Check the log file at $logFilePath for details."
