#!/bin/sh
export GRAAL_HOME=$HOME/graalvm/sulong
$HOME/graalvm/jruby/tool/jt.rb run --graal --jexceptions -r ./.jruby\+truffle_bundle/bundler/setup.rb test.rb
