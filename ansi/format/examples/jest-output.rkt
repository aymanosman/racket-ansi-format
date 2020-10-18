#lang racket

(require ansi/format)

(display-ansi yellow "warning " reset
              "package.json: No license field\n"
              dim "$ jest\n" reset
              inverse bold green " PASS " reset
              dim " ./" reset
              bold "sum.test.js\n" reset
              green "  ✓ " reset
              dim "adds 1 + 2 to equal 3 (2 ms)\n\n" reset
              bold "Test Suites: "
              bright-green "1 passed" reset ", 1 total\n"
              bold "Tests:       "
              bright-green "1 passed" reset ", 1 total\n"
              bold "Snapshots:   " reset
              "0 total\n"
              bold "Time:        " reset
              "0.916 s, estimated 1 s\n"
              dim "Run all test suites.\n" reset
              "✨  Done in 1.57s.\n")

(newline)

(display-ansi (yellow "warning") " package.json No license field\n"
              (dim "$ jest\n")
              (inverse (bold (green " PASS "))) (dim " ./") (bold "sum.test.js\n")
              (green "  ✓ ") (dim "adds 1 + 2 to equal 3 (2 ms)\n\n")
              (bold "Test Suites: ") (bright-green "1 passed") ", 1 total\n"
              (bold "Tests:       ") (bright-green "1 passed") ", 1 total\n"
              (bold "Snapshots:   ") "0 total\n"
              (bold "Time:        ") "0.916 s, estimated 1 s\n"
              (dim "Run all test suites.\n")
              "✨  Done in 1.57s.\n")
