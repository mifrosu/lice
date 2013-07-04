# Lice #

Lice is a Ruby script that allows batch insertion of licence headers into source files. The script identifies the file type from filename suffix or, in the case of a script, the hash-bang line, and comments the header appropriately.

Lice will reflow the licence text to ensure line length (with new comments) does not exceed 79 characters.

## Usage ##

        lice <licence_file> <source_files>

## Features ##

* check file type, and take action accordingly
* assign correct comment variable
* check licence file line length + comments and reflow if required
* add markers to allow for undo process
* leave hash-bang lines untouched
* allow custom comment declaration

### To do ###

* settings file

