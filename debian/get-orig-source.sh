#!/bin/bash

UPSTREAM_VERSION=$1
UPSTREAM_HASH=$2

UTFCPP_HASH=$(git submodule status lib/utfcpp | cut -c2-41)

TEMPDIR=$(mktemp -d)

trap cleanup exit 2

cleanup() {
    rm -r $TEMPDIR
}

# so that the object for the submodule can be found
git fetch git://github.com/ledger/utfcpp.git

git archive --prefix=ledger-${UPSTREAM_VERSION}/ ${UPSTREAM_HASH} | tar -C $TEMPDIR -xf -
git archive --prefix=lib/utfcpp/ ${UTFCPP_HASH} | \
    tar -C $TEMPDIR/ledger-${UPSTREAM_VERSION} -xf -

tar -C $TEMPDIR -zcf ../ledger_${UPSTREAM_VERSION}.orig.tar.gz ledger-${UPSTREAM_VERSION}

