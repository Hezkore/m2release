# m2release.git
Automatically generate releases for Monkey2

Compiles & Compresses Monkey2 products

## Required
* Monkey2 http://monkeycoder.co.nz/
* 7-Zip http://www.7-zip.org/
* Portable versions are fine

## Usage
* Compile 'm2release.monkey2'
* Make a shortcut of 'm2release.exe'
* Don't forget to edit 'config.txt' in your Monkey2 'products' folder
* You can edit the same config settings via application arugments in your shortcut
* Change the 'Start in' path in your shortcut to your own project path
* Run shortcut
* A folder is created, compiled to and finally compressed into a 7z file

The final 7z file will be named after the name of your %project-%platform%architecture-%date-%time

The folder name will be your 'config' setting (release or debug)

### Source
m2release tries to compile your specified 'source' (source=my_source.monkey2)

If no 'source' is provided; m2release will try to figure out which file to compile via these steps

* m2release will look for 'main.monkey2' in your project path
* If 'main.monkey2' is not found, it will look for "<folder_name>.monkey2"
* If <folder_name> is 'src' or 'source' the previous folder name will instead be used

### Output
m2release will output to your specified 'output' (output=release_folder)

If no 'output' is provided; m2release will try to figure out where to output via these steps

* Depending on your 'config' setting the folder name can either be 'release' or 'debug'
* If the project is inside its own folder, output will happen in its own folder
* If the project is inside a folder named 'src' or 'source', output will happen in the previous folder

Latest releases @ http://hezkore.com/release/m2release/