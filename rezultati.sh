for x in exp/{mono*,tri*,pnorm*,chaintdnn/tdnn*,chain/tdnn_lstm/tdnn*,chain/tdnn/tdnn*,chaintdnn/tree_sp/*,chain/lstm*}/{decode*,test*} ; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done

