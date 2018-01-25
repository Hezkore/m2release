# mkrelease.git
Automatically generate releases for Monkey2

Compiles & Compresses Monkey2 products

## Required
* Monkey2 http://monkeycoder.co.nz/
* 7-Zip http://www.7-zip.org/
* Portable versions are fine

## Usage
* Compile 'mkrelease.monkey2'
* Make a shortcut of 'mkrelease.exe'
* Don't forget to edit 'config.txt' in your Monkey2 'products' folder
* You can edit the same config settings via application arugments in your shortcut
* Change the 'Start in' path in your shortcut to your own project path
* Run shortcut
* A folder is created, compiled to and finally compressed into a 7z file

The final 7z file will be named after the 4 first letters of your project-'config'-'type'(date-time)

The folder name will be your 'config' setting (release/debug)

### Source
mkrelease tries to compile your specified 'source' (source=my_source.monkey2)

If no 'source' is provided; mkrelease will try to figure out which file to compile via these steps

* mkrelease will look for 'main.monkey2' in your project path
* If 'main.monkey2' is not found, it will look for "<folder_name>.monkey2"
* If <folder_name> is 'src' the previous folder name will instead be used

### Output
mkrelease will output to your specified 'output' (output=release_folder)

If no 'output' is provided; mkrelease will try to figure out where to output via these steps

* Depending on your 'config' setting the folder name can either be 'release' or 'debug'
* If the project is inside its own folder, output will happen in its own folder
* If the project is inside a folder named 'src', output will happen in the previous folder