#!/bin/sh
export GRAAL_HOME=$HOME/graalvm/sulong
$HOME/graalvm/jruby/tool/jt.rb run --graal -r ./.jruby\+truffle_bundle/bundler/setup.rb app.rb >/dev/null 2>/dev/null &
SERVER_PID="$!"

while ! ab -n 10 http://127.0.0.1:4567/; do
	sleep 1
done

echo "Warmup"

ab -n 1000 http://127.0.0.1:4567/

echo "Measure"

ab -n 1000 http://127.0.0.1:4567/

kill "$SERVER_PID"

sleep 10

kill -KILL "$SERVER_PID"
