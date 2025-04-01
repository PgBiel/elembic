#!/usr/bin/env nu
def "main test" [--typst: string = "", --tests: string, --verbose (-v), --update (-u)] {
    print $"(ansi cyan)== (ansi blue_bold)Running tests for Typst version (ansi green_bold)($typst) (ansi cyan)==(ansi reset)"

    let target_file = if $typst == "" {
        "1-generic.png"
    } else {
        $"1-($typst).png"
    }

    let test_list = $tests | split row ","

    print $"1. (ansi blue)Moving conflicting files(ansi reset)"
    if $typst != "" {
        glob $"test/unit/{($tests)}/**/ref/1.png"
        | each {
            if (ls $in | first | get type)  == "symlink" {
                # Already ran this command before
                # Remove existing symlink
                print $"(ansi magenta)Deleting(ansi reset) existing link (ansi green)($in)"
                rm $in
            } else {
                print $"(ansi magenta)Moving(ansi green) ($in) (ansi reset)to (ansi green)(dirname $in)/1-old.png(ansi reset)"
                mv $in $"(dirname $in)/1-old.png"
            }
        } # ; mv $in $"(dirname $in)/1-old.png" }
    }

    print $"\n2. (ansi blue)Linking expected ref name to this Typst version(ansi reset)"
    glob $"test/unit/{($tests)}/**/ref"
    | each {
        let link = $"($in)/1.png"
        let target = $"($in)/($target_file)"

        print $"(ansi magenta)Linking(ansi green) ($link) (ansi reset)to (ansi green)($target)(ansi reset)"
        ln -s $target $link
    } # ; mv $in $"(dirname $in)/1-old.png" }

    print $"\n3. (ansi blue)Running tests(ansi reset)"
    $test_list
    | each {
        typst-test (if $update { "update" } else { "run" }) $in
        let x = $in
        if $update {
            glob $"test/unit/($x)/**/ref/1.png"
            | each {
                if (ls $in | first | get type) != "symlink" {
                    print $"(ansi magenta)Fixing(ansi reset) updated test at (ansi green)($in)(ansi reset)"
                    mv $in $"(dirname $in)/($target_file)"
                }
            }
        }
    }

    print $"\n4. (ansi blue)Done.(ansi reset)"
}

def main [] {}
