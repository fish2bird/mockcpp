-- use py2exe to build all the python files into an exe file.
-- please install py2exe first. http://www.py2exe.org/
-- usage: premake4 install

newaction {
   trigger     = "install",
   description = "Install the software",
   execute = function ()
	  os.execute("D:/Users/jelly/Anaconda3/python.exe setup.py py2exe")
   end
}
