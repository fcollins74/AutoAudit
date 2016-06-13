@ECHO OFF
powershell -noprofile -command "&{start-process powershell -ArgumentList '-noprofile -file \"%~dp0Auto Audit.ps1"\"' -verb RunAs}"