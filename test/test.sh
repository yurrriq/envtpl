#! /usr/bin/env bash

TMPFILE="$(mktemp)"
TESTDIR="$(dirname "$0")"
program=envtpl
cmd="$GOPATH/bin/$program"

if ! [ -x "$cmd" ]; then
    echo "*** Cannot find $cmd"
    exit 1
fi

echo "*** test with all variables set"
TAG_REGION=eu-west-1 TAG_DATACENTER=dc1 INTERVAL=2s OUTPUT_INFLUXDB_ENABLED=true HOSTNAME=localhost "$cmd" "$TESTDIR"/test.tpl >"$TMPFILE" 2>/dev/null
if ! diff "$TESTDIR"/test.txt "$TMPFILE" >/dev/null; then
    echo "*** $cmd does not produce expected result"
    echo "*** expected result:"
    cat "$TESTDIR"/test.txt
    echo "*** observed result:"
    cat "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

unset HOSTNAME
echo "*** test with missing variable but default missing behavior"
TAG_REGION=eu-west-1 TAG_DATACENTER=dc1 INTERVAL=2s OUTPUT_INFLUXDB_ENABLED=true "$cmd" "$TESTDIR"/test.tpl >"$TMPFILE"
if ! diff "$TESTDIR"/test-missing.txt "$TMPFILE" >/dev/null; then
    echo "*** $cmd does not produce expected result"
    echo "*** expected result:"
    cat "$TESTDIR"/test-missing.txt
    echo "*** observed result:"
    cat "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

echo "*** test with missing variable but zero missing behavior"
TAG_REGION=eu-west-1 TAG_DATACENTER=dc1 INTERVAL=2s OUTPUT_INFLUXDB_ENABLED=true "$cmd" -m zero "$TESTDIR"/test.tpl >"$TMPFILE"
if ! diff "$TESTDIR"/test-zero.txt "$TMPFILE" >/dev/null; then
    echo "*** $cmd does not produce expected result"
    echo "*** expected result:"
    cat "$TESTDIR"/test-zero.txt
    echo "*** observed result:"
    cat "$TMPFILE"
    rm "$TMPFILE"
    exit 1
fi

echo "*** test with missing variable and error behavior"
if TAG_REGION=eu-west-1 TAG_DATACENTER=dc1 INTERVAL=2s OUTPUT_INFLUXDB_ENABLED=true "$cmd" -m error "$TESTDIR"/test.tpl >"$TMPFILE" 2>&1; then
    echo "*** $cmd returned no error when it should have!"
    exit 1
fi

echo "*** Tests passed successfully"
rm "$TMPFILE"
