#!/bin/sh
JRUBYPATH=/home/david/graalvm/jruby
SULONGPATH=/home/david/graalvm/sulong
GRAALPATH=/home/david/graalvm/graal-core

# gem install sinatra
GEMS="rack-1.6.4 rack-protection-1.5.3 sinatra-1.4.7 tilt-2.0.5"
# gem install sinatra-activerecord
GEMS="$GEMS activemodel-4.2.6 activerecord-4.2.6 activesupport-4.2.6 arel-6.0.3 i18n-0.7.0 sinatra-activerecord-2.0.9 thread_safe-0.3.5-java tzinfo-1.2.2"
# gem install activerecord-jdbcsqlite3-adapter
GEMS="$GEMS activerecord-jdbc-adapter-1.3.20 activerecord-jdbcsqlite3-adapter-1.3.20 jdbc-sqlite3-3.8.11.2"

GEMS="`ls -1 $JRUBYPATH/lib/ruby/gems/shared/gems`"
echo $GEMS

INCLUDEPATH="`echo "$GEMS" | sed 's|\([^ ]*\)|-I'$JRUBYPATH'/lib/ruby/gems/shared/gems/\1/lib|g'`"
#$JRUBYPATH/bin/jruby -X+T -Xtruffle.core.load_path=$JRUBYPATH/truffle/src/main/ruby -Xtruffle.graal.warn_unless=false $INCLUDEPATH $JRUBYPATH/bin/irb
$JRUBYPATH/bin/jruby -X+T -Xtruffle.core.load_path=$JRUBYPATH/truffle/src/main/ruby -Xtruffle.graal.warn_unless=false $INCLUDEPATH -Igems/sinatra-enotify/lib app.rb

#JAVACMD=/home/david/graalvm/sulong/../jvmci/jdk1.8.0_91/product/bin/java $JRUBYPATH/bin/jruby -X+T -Xtruffle.core.load_path=$JRUBYPATH/truffle/src/main/ruby -Xtruffle.graal.warn_unless=false -J-classpath "$SULONGPATH/lib/*" -J-classpath $SULONGPATH/build/sulong.jar -J-classpath $GRAALPATH/mxbuild/graal/com.oracle.nfi/bin -J-XX:-UseJVMCIClassLoader $INCLUDEPATH app.rb
