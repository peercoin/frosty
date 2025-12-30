#!/bin/bash

OUTPUTDIR=$THISDIR/../platform-build
VERSION=4.0.0
LOCALBUILDDIR=$THISDIR/../frosty/build

# Create build and output directories
mkdir -p $OUTPUTDIR $LOCALBUILDDIR

# Build into output directory
cd $OUTPUTDIR
