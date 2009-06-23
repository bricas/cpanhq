#!/bin/sh
ctags -f tags --recurse --totals \
    --exclude='**/blib/**' --exclude='blib/**' --exclude='**/t/lib/**' \
    --exclude='**/.svn/**' --exclude='.git/**' --exclude='*~' \
    --exclude='CPANHQ-*/**' \
    --languages=Perl --langmap=Perl:+.t
