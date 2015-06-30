import sys

def all_casings(input_string):
    if not input_string:
        yield ""
    else:
        first = input_string[:1]
        if first.lower() == first.upper():
            for sub_casing in all_casings(input_string[1:]):
                yield first + sub_casing
        else:
            for sub_casing in all_casings(input_string[1:]):
                yield first.lower() + sub_casing
                yield first.upper() + sub_casing

with open(str(sys.argv[1])) as f:
    for line in f.readlines():
        print line
        print "".join(list(all_casings(line)))

# TIPS

# Remove lines less than 8 characters: sed '/.\{8\}/!d'
# Sort and remove duplicates: sort -u $FILE


#print [x for x in all_casings("foo")]

#print "\n".join(list(all_casings("foo")))
