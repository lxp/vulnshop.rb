#!/bin/sh

export SULONG_HOME="$HOME/graalvm/sulong"
export JRUBY_HOME="$HOME/graalvm/jruby"

"$JRUBY_HOME/bin/gem" install bundler
"$JRUBY_HOME/bin/jruby+truffle" setup
