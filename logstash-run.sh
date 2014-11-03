#!/bin/bash

# Fail fast, including pipelines
#set -eo pipefail

# Set LOGSTASH_TRACE to enable debugging
#[[ $LOGSTASH_TRACE ]] && set -x

# Fire up logstash!
exec /opt/logstash/bin/logstash agent -f /etc/logstash.conf