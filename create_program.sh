#! /bin/zsh

rm program.f 2> /dev/null
cat jonesforth.f    \
    se-ans.f        \
    utils.f         \
    i2c.f           \
    | ./unify_and_uncomment.py
