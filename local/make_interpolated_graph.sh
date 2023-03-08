#!/usr/bin/env bash

set -e
. ./path.sh
. utils/parse_options.sh
. ./cmd.sh

text_dir=data/face2text
text_file=opisovanje_obrazov.txt

tree_dir=exp/chain/tdnn/tdnn1a_sp
tdnn_dir=exp/chain/tdnn/tree_1a_sp
lang=data/lang_obrazi

echo "make_interpolated_graph.sh: Interpolating language model in \"${lang}\" ..."
echo "###########################################################################################"

ngram-count -order 3 \-write-vocab $text_dir/${text_file%%.txt}.vocab -wbdiscount -text $text_dir/$text_file -lm $text_dir/${text_file%%.txt}.arpa
arpa2fst --disambig-symbol=#0 --read-symbol-table=$lang/words.txt $text_dir/${text_file%%.txt}.arpa $lang/G.fst
utils/mkgraph.sh --self-loop-scale 1.0 $lang $tree_dir $tdnn_dir/graph_obrazi
