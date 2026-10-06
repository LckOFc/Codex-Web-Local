@echo off
setlocal EnableExtensions EnableDelayedExpansion

cd /d "%~dp0"

set "BUN_VERSION=1.4.0"
set "BUILD_ENV=%TEMP%\codex-web-local-build-%RANDOM%-%RANDOM%.env"

echo.
echo ========================================
echo   Codex Web Local - Windows Builder
echo ========================================
echo.

where powershell.exe >nul 2>nul
if errorlevel 1 (
  echo [ERRO] PowerShell nao foi encontrado.
  goto :fail
)

echo [1/6] Preparando Bun %BUN_VERSION% para Windows...
set "RUNNER_TEMP=%TEMP%"
type nul > "%BUILD_ENV%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\prepare-windows-baseline-bun.ps1" -Version "%BUN_VERSION%" -GitHubEnv "%BUILD_ENV%"
if errorlevel 1 goto :fail

for /f "usebackq tokens=1,* delims==" %%A in ("%BUILD_ENV%") do (
  if /i "%%A"=="CODEX_CHATGPT_WEB_EMBEDDED_BUN" set "CODEX_CHATGPT_WEB_EMBEDDED_BUN=%%B"
)
del /q "%BUILD_ENV%" >nul 2>nul

if not defined CODEX_CHATGPT_WEB_EMBEDDED_BUN (
  echo [ERRO] O runtime Bun baseline nao foi preparado corretamente.
  goto :fail
)

set "CODEX_WEB_GPT_BUN=!CODEX_CHATGPT_WEB_EMBEDDED_BUN!"
for %%D in ("!CODEX_CHATGPT_WEB_EMBEDDED_BUN!") do set "PATH=%%~dpD;!PATH!"

for /f "delims=" %%V in ('bun --version 2^>nul') do set "CURRENT_BUN=%%V"
if /i not "!CURRENT_BUN!"=="%BUN_VERSION%" (
  echo [ERRO] Bun incorreto. Esperado %BUN_VERSION%, recebido !CURRENT_BUN!.
  goto :fail
)

echo [2/6] Instalando dependencias da raiz...
bun install --frozen-lockfile
if errorlevel 1 goto :fail

echo [3/6] Instalando dependencias do launcher...
pushd launcher
bun install --frozen-lockfile
if errorlevel 1 (
  popd
  goto :fail
)
popd

echo [4/6] Verificando o projeto...
bun run verify
if errorlevel 1 goto :fail

echo [5/6] Compilando launcher e runtime...
echo [6/6] Gerando instalador Windows NSIS...
bun run --cwd launcher package:win
if errorlevel 1 goto :fail

if not exist "%~dp0launcher\artifacts\*.exe" (
  echo [ERRO] A compilacao terminou sem gerar um instalador .exe.
  goto :fail
)

echo.
echo ========================================
echo   BUILD CONCLUIDO COM SUCESSO
echo ========================================
echo.
echo Instalador gerado em:
echo   %~dp0launcher\artifacts\
echo.
dir /b "%~dp0launcher\artifacts\*.exe" 2>nul
echo.
pause
exit /b 0

:fail
if exist "%BUILD_ENV%" del /q "%BUILD_ENV%" >nul 2>nul
echo.
echo ========================================
echo   FALHA NA COMPILACAO
echo ========================================
echo Verifique a mensagem de erro acima.
echo.
pause
exit /b 1
