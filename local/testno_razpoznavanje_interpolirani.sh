#!/bin/bash

# Adapted from egs/mini_librispeech/s5/local/chain/tuning/run_tdnn_1g.sh

# Set -e here so that we catch if any executable fails immediately
set -euo pipefail

nnet3=tdnn
affix=1a   # affix for the TDNN directory name
#graph="graph_splosni"
graph="graph_obrazi"

decode_nj=1
test_sets="test "
#test_sets="obrazi "

# End configuration section.
echo "$0 $@"  # Print the command line for logging

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

tree_dir=exp/chain/${nnet3}/tree_${affix}_sp
dir=exp/chain/${nnet3}/tdnn${affix}_sp

chunk_width=140,100,160
# we don't need extra left/right context for TDNN systems.
chunk_left_context=0
chunk_right_context=0
frames_per_chunk=$(echo $chunk_width | cut -d, -f1)

rm $dir/.error 2>/dev/null || true
for data in $test_sets; do

    # Creating acoustical features
    mkdir -p data/${data}_hires
    cp data/${data}/* data/${data}_hires/
    steps/make_mfcc.sh --nj ${decode_nj} --mfcc-config conf/mfcc_hires.conf --cmd run.pl data/${data}_hires exp/make_mfcc/${data} mfcc
    steps/compute_cmvn_stats.sh data/${data}_hires exp/make_mfcc/${data} mfcc

    nspk=$(wc -l <data/${data}_hires/spk2utt)
    steps/nnet3/decode.sh \
        --acwt 1.0 --post-decode-acwt 10.0 \
        --extra-left-context $chunk_left_context \
        --extra-right-context $chunk_right_context \
        --extra-left-context-initial 0 \
        --extra-right-context-final 0 \
        --frames-per-chunk $frames_per_chunk \
        --nj ${decode_nj} --num-threads 1 \
        $tree_dir/${graph} data/${data}_hires ${dir}/decode_${graph}_v2_${data} || exit 1
done

[ -f $dir/.error ] && echo "$0: there was a problem while decoding" && exit 1
