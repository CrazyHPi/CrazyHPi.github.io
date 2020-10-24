@echo off
color a

TITLE TeamSpeak 3 Server Blacklisted status remover v1.0

echo.

echo TeamSpeak 3 Server Blacklisted status remover v1.0

:choice

SET /P C="This action will remove teamspeak3 server blacklisted status by alter your Windows firewall rules and your system hosts file. Do you wish to continue? [Y/n]: "

for %%? in (Y) do if /I "%C%"=="%%?" goto setup

for %%? in (n) do if /I "%C%"=="%%?" exit

goto choice

:setup

taskkill /f /im "ts3client_win32.exe" > NUL

taskkill /f /im "ts3client_win64.exe" > NUL

netsh advfirewall firewall add rule name="IP Block TeamSpeak Blacklist" dir=out interface=any action=block remoteip=104.20.74.196/32

del "%APPDATA%\TS3Client\resolved.dat" > NUL

del "%APPDATA%\TS3Client\cache.dat" > NUL

del "%APPDATA%\TS3Client\cache\webserverlist.dat" > NUL

del "%APPDATA%\TS3Client\cache\webserverlistcache.dat" > NUL

echo 0.0.0.0 blacklist2.teamspeak.com >> echo.>>%systemroot%\system32\drivers\etc\hosts

echo 127.0.0.1 blacklist2.teamspeak.com >> echo.>>%systemroot%\system32\drivers\etc\hosts

echo 0.0.0.0 104.20.74.196 >> echo.>>%systemroot%\system32\drivers\etc\hosts

echo 127.0.0.1 104.20.74.196 >> echo.>>%systemroot%\system32\drivers\etc\hosts

echo Now you may able to connect to blacklisted servers.

pause