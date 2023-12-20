@echo off 
chcp 65001
cls
echo Olá meus amigos
color 0a
for /f "usebackq" %%i in (`hostname`) do (
	set nomeHost=%%i 
	goto :done
)
:done
echo Nome do host: %nomeHost%  >>dados-info.txt

echo.
for /f "usebackq skip=1" %%i in (`wmic baseboard get Product`) do (
	set placaMae=%%i
	goto :done
)
:done
echo Placa-Mãe: %placaMae%  >>dados-info.txt

echo.
for /f "usebackq skip=1" %%i in (`wmic bios get smbiosbiosversion`) do (
	set versaoBios=%%i
	goto :done
)
:done
echo BIOS: %versaoBios%  >>dados-info.txt

echo.
echo CPU:  >>dados-info.txt
wmic CPU get NAME | find /v "Name"  >>dados-info.txt

echo Tipo de Memória RAM:  >>dados-info.txt
echo
wmic memorychip get memorytype | find /v "MemoryType" >>dados-info.txt

echo Frequencia de Memória RAM:  >>dados-info.txt
wmic memorychip get speed | find /v "Speed"  >>dados-info.txt

echo Quantidade de Memória RAM:  >>dados-info.txt
wmic memorychip get capacity | find /v "Capacity"  >>dados-info.txt

echo Dispositivos de Armazenamento:  >>dados-info.txt
wmic diskdrive get model | find /v "Model"  >>dados-info.txt

echo Endereços IP:  >>dados-info.txt
setlocal
setlocal enabledelayedexpansion
for /f "usebackq tokens=*" %%a in (`ipconfig ^| findstr /i "ipv4"`) do ( 
	for /f delims^=^:^ tokens^=2 %%b in ('echo %%a') do (
		for /f "tokens=1-4 delims=." %%c in ("%%b") do (
			set _o1=%%c
			set _o2=%%d
			set _o3=%%e
			set _o4=%%f
			set _4octet=!_o1:~1!.!_o2!.!_o3!.!_o4!
			echo !_4octet!
		)
   )
)  >>dados-info.txt
endlocal

echo.
echo Endereço MAC e Informações da placa de Rede:  >>dados-info.txt
wmic nic where (AdapterTypeId=0 AND netConnectionStatus=2) get MACAddress,Name | find /v "MACAddress" >>dados-info.txt

echo Usuários: >>dados-info.txt
wmic useraccount get name | findstr /V "Convidado DefaultAccount SEUM-User WDAGUtility" | find /v "Name" >>dados-info.txt