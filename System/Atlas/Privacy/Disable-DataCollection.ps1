Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled
Remove-Item -Path "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\DiagTrack*" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Diagnosis\ETLLogs\ShutdownLogger\DiagTrack*" -Force -ErrorAction SilentlyContinue