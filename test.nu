#!/usr/bin/env nu
def "main test" [--typst: string = "", --tests: string = "", --verbose (-v), --update (-u)] {
    print $"(ansi cyan)== (ansi blue_bold)Running tests for Typst version (ansi green_bold)($typst) (ansi cyan)==(ansi reset)"

    if (which typst-test | length) == 0 {
        print $"(ansi red)Error: (ansi green)typst-test (ansi red)is not installed."
        exit 1
    }
    let target_folder = if $typst == "" {
        "generic"
    } else {
        $typst
    }
    let test_list = $tests | split row ","
    let test_glob_part = if $tests == "" { "" } else { $"{($tests)}" }
    let test_dirs = glob ("test/unit" | path join $test_glob_part "**/v-ref") | each { path dirname }

    def verbose_print [message: string] {
        if $verbose {
            print $message
        }
    }

    if $verbose {
        print $"(ansi cyan)Found the following versioned tests:(ansi reset) ($test_dirs | str join ',')"
    } else {
        print $"(ansi cyan)Found (ansi green)($test_dirs | length) (ansi cyan)versioned tests.(ansi reset)"
    }

    print $"1. (ansi blue)Moving conflicting files(ansi reset)"

    $test_dirs
    | each {|test|
        # if ($ref | path type) == "symlink" {
        #     # Already ran this command before
        #     # Remove existing symlink
        #     verbose_print $"(ansi magenta)Deleting(ansi reset) existing link (ansi green)($ref)(ansi reset)"
        #     rm $ref
        #     return
        # }
        let ref = $test | path join "ref"
        if ($ref | path exists) {
            let ref_bup = $test | path join "ref.bup"
            verbose_print $"(ansi magenta)Moving(ansi green) ($ref) (ansi reset)to (ansi green)($ref_bup)(ansi reset)"
            mv $ref $ref_bup
        }
    }

    print $"\n2. (ansi blue)Moving 'v-ref/($target_folder)' to 'ref' for each versioned test(ansi reset)"

    $test_dirs
    | each {
        let orig = $"($in)/v-ref/($target_folder)" | readlink -m $in # follow symlinks
        let dest = $"($in)/ref"
        if ($orig | path exists) {
            verbose_print $"(ansi magenta)Moving(ansi green) ($orig) (ansi reset)to (ansi green)($dest)(ansi reset)"
            mv $orig $dest
        } else {
            verbose_print $"(ansi magenta)Creating(ansi green) ($dest) (ansi reset)"
            mkdir $dest
        }
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

    print $"\n4. (ansi blue)Saving test references and restoring backups(ansi reset)"

    $test_dirs
    | each {|test|
        let ref = $test | path join "ref"
        let test_ref = $test | path join "v-ref" $target_folder | readlink -m $in # follow symlinks
        let bup = $test | path join "ref.bup"
        verbose_print $"(ansi magenta)Moving(ansi green) ($ref) (ansi reset)to (ansi green)($test_ref)(ansi reset)"
        mv $ref $test_ref
        if ($bup | path exists) {
            verbose_print $"(ansi magenta)Moving(ansi green) ($bup) (ansi reset)to (ansi green)($ref)(ansi reset)"
            mv $bup $ref
        }
    }

    print $"\n5. (ansi blue)Done.(ansi reset)"

    let failures = ($test_list | length) - ($result)
    if $failures == 0 {
        print $"(ansi green)All ($result) tests passed!"
    } else {
        print $"(ansi red)Some tests or subtests failed.(ansi green) ($result) (ansi reset)OK, (ansi red)($failures)(ansi reset) failed."
        exit 1
    }
}

def main [] {}
