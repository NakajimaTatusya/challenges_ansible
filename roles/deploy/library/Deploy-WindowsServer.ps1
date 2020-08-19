# required charactor code utf-8 BOM

# import config
. "D:\temp\config.ps1"
# Windows Server 2016 
# Get-WindowsImage -ImagePath "d:\sources\install.wim" の結果。ISOイメージをマウントして、install.wim からインストールイメージの名称を取得した。
# !!! ImageNameだとうまくいかない、ImageIndexでうまくいった。 !!!
# index=1 name=Windows Server 2016 Standard Evaluation
# index=2 name=Windows Server 2016 Standard Evaluation (デスクトップ エクスペリエンス)
# index=3 name=Windows Server 2016 Datacenter Evaluation
# index=4 name=Windows Server 2016 Datacenter Evaluation (デスクトップ エクスペリエンス)
# select and set to Edtion variable.
. "D:\temp\Convert-WindowsImage.ps1"

if ((Get-Item $unattend_file_path) -is [System.IO.DirectoryInfo])
{
    Write-Host "unattend file が見つかりません。"
    exit
}

# call convert windows image -----start-----
$ConvertParams = @{
    SourcePath = $conv_src_path
    SizeBytes = $vm_hdd_size
    Edition = 2
    VHDFormat = "VHDX"
    VHDPath = $vhdx_output_path
    DiskLayout = "UEFI"
    UnattendPath = $unattend_file_path
}
Convert-WindowsImage @ConvertParams -Verbose
# call convert windows image -----end-----

# setting HyperV and start vm -----satart-----
Write-Host "create VM Switch"
$work = Get-VMSwitch | Select-Object Name | Where-Object {$_.Name -eq $vm_switch}
if (-not $work)
{
    New-VMSwitch -name $vm_switch  -NetAdapterName $network_adapter_name -AllowManagementOS $true
}
# vhdx ファイル無しで起動する(マックアドレスをとるため)
Write-Host "create new VM."
New-VM -Name $vm_name -Path $vm_home_path -MemoryStartupBytes $vm_memory_size -SwitchName $vm_switch -Generation 2 -NoVHD
Write-Host "Add DVD Drive."
Get-VMIdeController -VMName $vm_name | Add-VMDvdDrive -Path D:\

Write-Host "一時的に VM satrt"
Start-VM $vm_name
Start-Sleep 5
Write-Host "VM stop"
Stop-VM $vm_name -Force
Start-Sleep 5

Write-Host "マックアドレスを設定します"
$MACAddress = get-VMNetworkAdapter -VMName $vm_name | Where-Object {$_.SwitchName -eq $vm_switch} | Select-Object MacAddress -ExpandProperty MacAddress
$MACAddress = ($MACAddress -replace '(..)', '$1-').trim('-')
get-VMNetworkAdapter -VMName $vm_name | Where-Object {$_.SwitchName -eq $vm_switch} | Set-VMNetworkAdapter -StaticMacAddress $MACAddress

Write-Host "set vhdx file."
$vhdx_file_name = [System.IO.Path]::GetFileName($vhdx_output_path)
$compath = Join-Path $vm_vhd_path $vhdx_file_name
if (-not (Test-Path $vm_vhd_path))
{
    New-Item $vm_vhd_path -ItemType Directory
}
Write-Host "Source Path : "$vhdx_output_path
Write-Host "Destination Path : "$compath
Write-Host "vhdxファイルを対象のパスへコピー"
Copy-item $vhdx_output_path -Destination $compath
Set-VM -Name $vm_name -ProcessorCount $vm_cpu_count -AutomaticStartAction Start -AutomaticStopAction ShutDown -AutomaticStartDelay 5
Add-VMHardDiskDrive -VMName $vm_name -ControllerType SCSI -Path $compath

$vhdx_file_name_no_extention = [System.IO.Path]::GetFileNameWithoutExtension($vhdx_output_path)
$Drive = Get-VMHardDiskDrive -VMName $vm_name | Where-Object { $_.Path -like "$vhdx_file_name_no_extention*" }
Get-VMFirmware -VMName $vm_name | Set-VMFirmware -FirstBootDevice $Drive

Write-Host "mount vhdx."
Mount-VHD -Path $compath
Write-Host "get drive letter from mount vhdx."
$VolumeDriveLetter = GET-DISKIMAGE $compath | GET-DISK | GET-PARTITION | get-volume | Where-Object { $_.FileSystemLabel -ne "Recovery" } | Select-Object DriveLetter -ExpandProperty DriveLetter
$DriveLetter = $VolumeDriveLetter + ":"
Write-Host "Unattend.xml を vhdx へコピー"
Copy-Item $unattend_file_path $DriveLetter\unattend.xml
Write-Host "vhdx ファイルをアンマウント"
Dismount-Vhd -Path $compath

Write-Host "VM 起動"
Start-VM $vm_name
# setting HyperV and start vm -----end-----

Write-Host "処理終了"
