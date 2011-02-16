IF "x%1"=="x" (
	dir "C:\Program Files\Microsoft Visual Studio\VC98\Bin\*.exe"
	) ELSE (
	dir "C:\Program Files\Microsoft Visual Studio\VC98\Bin\%1" %2%3%4%5%6
	)