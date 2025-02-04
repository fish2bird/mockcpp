# This is a Windows PowerShell script
# On windows 7, open cmd.exe, input powershell, hit enter, then you can run this script.
# If you use powershell the first time, excute this cmd first: set-executionpolicy remotesigned
# Build mockcpp and it's tests, and at last run all tests.


# add vcbuild path  and cmake path
# It's better to add to your computer's path environment variable, than to modify $env:path below.
#$env:path=$env:path+";C:\Program Files\Microsoft Visual Studio 9.0\VC\vcpackages"
#$env:path=$env:path+";D:\Tools\CMD\cmake-2.8.1-win32-x86\bin"

# specify the Visual Studio Version, not set to use default
#$VC_VER="-G `"Visual Studio 9 2008`""
$VC_VER="-G `"Visual Studio 16 2019`"" 

# build Debug only
$env:VCBUILD_DEFAULT_CFG="Debug|Win32"

function build($build_dir, $src_dir) { 
	if (!(test-path $build_dir)) { mkdir $build_dir }
	cd $build_dir
	Invoke-Expression "cmake $src_dir $VC_VER"
	#ls *.sln -name | vcbuild
}

build ..\..\..\..\build_testngpp ..\mockcpp\tests\3rdparty\testngpp

build ..\build_testngpp_testngppst ..\mockcpp\tests\3rdparty\testngpp\tests\3rdparty\testngppst

build ..\build_testngpp_tests ..\mockcpp\tests\3rdparty\testngpp\tests


#---------------------------------
# run all tests
cd ut\Debug
cp ..\..\..\build_testngpp_testngppst\src\listeners\Debug\testngppststdoutlistener.dll .
$ALL_DLL=(ls *.dll -name)-replace ".dll" | where {$_ -ne "testngppststdoutlistener"}
..\..\..\build_testngpp_testngppst\src\runner\Debug\testngppst-runner.exe $ALL_DLL -L"..\..\..\build_testngpp_testngppst\src\listeners\Debug" -l"testngppststdoutlistener -c -v" -m
cd ..\..\..\mockcpp\tests\3rdparty\testngpp

# All tests pass on vs2019 with -m option.
# if run without -m, then TestMemChecker, TestXMLBuilder, TestXMLTestListener report memory leak.
