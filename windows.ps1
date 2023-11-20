# ---------------------------------------------------------------------------- #
#                               windows settings                               #
# ---------------------------------------------------------------------------- #

# -------------------------- login screen background ------------------------- #
Set-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\Personalization" "LockScreenImage" "$PWD\wallpapers\rose-pine\rose_pine_circle2.png"
# --------------------------------- wallpaper -------------------------------- #
$wallpaperPath = "$PWD\wallpapers\rose-pine"
# Select random File from wallpaperPath
$wallpaperFile = Get-ChildItem -name -Path $wallpaperPath | Select-Object -index (Get-Random -Maximum ((Get-ChildItem -Path $wallpaperPath).Count))
Set-ItemProperty -path "HKCU:\Control Panel\Desktop\" -name wallpaper -value "$wallpaperPath\$wallpaperFile"
rundll32.exe user32.dll, UpdatePerUserSystemParameters
# ------------------------------- accent color ------------------------------- #
# Set accent color to rose-pine
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\DWM" "AccentColor" "0x31748f"