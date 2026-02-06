@echo off
REM ============================================================================
REM Alias pour utiliser Node.js v10.24.1
REM ============================================================================
REM Version: 1.0.0
REM Date: 2026-02-02
REM Auteur: Franck Desmedt / Kiro
REM ============================================================================
REM
REM Ce script configure l'environnement pour utiliser Node v10.24.1
REM Compatible avec Angular 5
REM
REM Usage:
REM   call Use-Node10.bat
REM   node --version
REM   npm --version
REM ============================================================================

set NODE_V10_PATH=C:\Users\franck.desmedt\dev\nodejs-versions\node-v10.24.1-win-x64

REM Vérifier que Node v10 existe
if not exist "%NODE_V10_PATH%\node.exe" (
    echo [ERREUR] Node.js v10.24.1 introuvable dans %NODE_V10_PATH%
    echo Veuillez verifier le chemin d'installation de Node.js
    exit /b 1
)

REM Ajouter Node v10 au PATH (en premier pour priorité)
set PATH=%NODE_V10_PATH%;%PATH%

REM Définir les variables d'environnement pour les scripts
set NODE_PATH=%NODE_V10_PATH%
set NODE_EXE=%NODE_V10_PATH%\node.exe
set NPM_CMD=%NODE_V10_PATH%\npm.cmd

echo [INFO] Node.js v10.24.1 active
