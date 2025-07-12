:: This script runs .NET Native Image Generator (ngen) to update and compile assemblies for better performance.
:: It checks both 32-bit and 64-bit .NET Framework directories and executes any queued ngen tasks.
:: References:
:: - http://support.microsoft.com/kb/2570538
:: - http://robrelyea.wordpress.com/2007/07/13/may-be-helpful-ngen-exe-executequeueditems/
:: Script exits gracefully even if ngen operations fail.

if exist %windir%\microsoft.net\framework\v4.0.30319\ngen.exe (
	%windir%\microsoft.net\framework\v4.0.30319\ngen.exe update /force /queue
	%windir%\microsoft.net\framework\v4.0.30319\ngen.exe executequeueditems
)
if exist %windir%\microsoft.net\framework64\v4.0.30319\ngen.exe (
	%windir%\microsoft.net\framework64\v4.0.30319\ngen.exe update /force /queue
	%windir%\microsoft.net\framework64\v4.0.30319\ngen.exe executequeueditems
)

:: continue even if ngen fails
exit /b 0
