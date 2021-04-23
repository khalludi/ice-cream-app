@ECHO OFF
setlocal DISABLEDELAYEDEXPANSION
SET BIN_TARGET=%~dp0/../google/cloud-debugger/bin/google-cloud-debugger
php "%BIN_TARGET%" %*
