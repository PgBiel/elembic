#!/usr/bin/env nu
def "main test" [--typst: string = "", --tests: string, --verbose (-v), --update (-u)] {
    print $"(ansi cyan)== (ansi blue_bold)Running tests for Typst version (ansi green_bold)($typst) (ansi cyan)==(ansi reset)"

    let target_folder = if $typst == "" {
        "generic"
    } else {
        $typst
    }

    let test_list = $tests | split row ","


    print $"1. (ansi blue)Moving conflicting files(ansi reset)"

    glob $"test/unit/{($tests)}/**/ref" --exclude [$"test/unit/{($tests)}/**/v-ref/**"]
    | each {|ref|
        if not ($ref | path exists) {
            return
        }
        if ($ref | path type) == "symlink" {
            # Already ran this command before
            # Remove existing symlink
            print $"(ansi magenta)Deleting(ansi reset) existing link (ansi green)($ref)(ansi reset)"
            rm $ref
            return
        }
        let ref_bup = $ref | path basename --replace "ref.bup"
        print $"(ansi magenta)Moving(ansi green) ($ref) (ansi reset)to (ansi green)($ref_bup)(ansi reset)"
        mv $ref $ref_bup
    }

    print $"\n2. (ansi blue)Linking expected ref folder to this Typst version(ansi reset)"

    glob $"test/unit/{($tests)}/**/{ref,ref.bup,v-ref,out}" --exclude [$"test/unit/{($tests)}/**/v-ref/**/ref"]
    | each { path dirname }
    | uniq
    | each {
        let link = $"($in)/ref"
        let target = $"($in)/v-ref/($target_folder)"
        mkdir $target

        print $"(ansi magenta)Linking(ansi green) ($link) (ansi reset)to (ansi green)($target)(ansi reset)"
        ln -s $target $link
    }

    print $"\n3. (ansi blue)Running tests(ansi reset)"
    let result = $test_list
        | each {
            try {
                typst-test (if $update { "update" } else { "run" }) $in
                true
            } catch {
                false
            }
        }
        | filter { $in }
        | length

    print $"\n4. (ansi blue)Restore backups, delete links(ansi reset)"

    glob $"test/unit/{($tests)}/**/ref" --exclude [$"test/unit/{($tests)}/**/v-ref/**"]
    | each {
        let orig = $in
        let bup = $in | path basename --replace "ref.bup"
        if ($bup | path exists) {
            print $"(ansi magenta)Moving(ansi green) ($bup) (ansi reset)to (ansi green)($orig)(ansi reset)"
            mv $bup $orig
        } else {
            print $"(ansi magenta)Deleting(ansi reset) temporary link (ansi green)($orig)(ansi reset)"
            rm $orig
        }
    }

    print $"\n5. (ansi blue)Done.(ansi reset)"

    let failures = ($test_list | length) - ($result)
    if failures == 0 {
        print $"(ansi green)All ($result) tests passed!"
    } else {
        print $"(ansi red)Some tests or subtests failed.(ansi green) ($result) (ansi reset)OK, (ansi red)($failures)(ansi reset) failed."
    }
}

def main [] {}
