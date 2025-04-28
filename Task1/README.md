1. Breakdown of how the script handles arguments and options
My script mygrep.sh first checks if the user asked for --help, or if the number of arguments is missing or wrong. If something is wrong, it shows a usage error and exits safely.

If options like -n, -v, or combinations like -vn are provided, the script uses basic string matching and grep-like behavior by adjusting flags internally:

-n ➔ Adds line numbers to the output.

-v ➔ Inverts the match, meaning it shows lines not matching the search term.

Both -v and -n can be combined.

The script uses a case-insensitive match by default (by using grep -i or equivalent behavior in awk/bash).
Finally, it prints the output in a format similar to the real grep.

The arguments are split like this:

First, check if the first argument is an option (starting with -).

Then extract the search string.

Then extract the filename.

If any part is missing, it prints an error message.

2. How the structure would change if supporting regex or -i/-c/-l options
If I wanted to support more features like:

Regex ➔ I would avoid plain grep simple string matching, and instead allow regular expression searching by using grep -E (for extended regex) or a Bash tool like awk or sed that can handle patterns.

-i (ignore case) ➔ I would add an internal flag like ignore_case=true, and pass -i to grep based on that.

-c (count matches) ➔ Instead of printing matching lines, I would count how many matches there are and print only the number.

-l (list files with matches) ➔ If the match is found, just print the filename, not the line itself.

This would make the script a little more complex. I would use variables to track each option (show_line_number, invert_match, ignore_case, etc.) and then build the final command dynamically depending on which options are true.

I would also use getopts to better handle multiple options parsing in a clean way, rather than manually checking arguments.

3. What part of the script was hardest to implement and why
The hardest part was handling combinations of options like -vn, -nv, or just -v or -n separately.
I also had to carefully think about the order of checking so that the script wouldn't crash if arguments were missing.

Learning how to mimic grep's behavior as closely as possible and making the output look nice was also a challenge, but it helped me understand Bash scripting better.