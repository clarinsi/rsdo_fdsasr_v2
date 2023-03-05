# Face-Domain-Specific Automatic Speech Recognition Models

This repository contains all the necessary files required for implementing face-domain-specific automatic speech recognition (ASR) applications using the Kaldi toolkit, including the acoustic model, language model, and other relevant files. The repository also includes all the scripts and configuration files needed to use these models for implementing the face-domain-specific specific automatic speech recognition.

The acoustical model was trained using the relevant Kaldi tools and the Artur speech corpus. The language model was trained using the domain-specific text data that involve face descriptions and which were obtained by translating the Face2Text English corpus into the Slovenian language. These models, combined with other necessary files like the HCLG.fst and decoding scripts, enable the implementation of face-domain-specific ASR applications.

# Prerequisites

To use the acoustical and language models provided in this GitHub repository for implementing face-domain-specific automatic speech recognition (ASR), there are several prerequisites that should be met:
1.  Data: The models in the repository were trained on specific speech data. Therefore, it is essential to have access to similar data to ensure the models can accurately recognize speech in the face-domain.
2.  Computing resources: Using the provided acoustical and language model can require significant computing resources. Decoding (using the models to transcribe speech) can be computationally intensive and may require a computer with a fast processor and sufficient memory.
3.  Kaldi toolkit: The Kaldi toolkit should be used to use the models in the repository. Before using the models, it is necessary to have Kaldi installed and properly configured on your computer.
4.  Dependencies: The models may rely on additional software packages or dependencies. Before using the models, it is important to ensure that all the necessary dependencies are installed and configured properly.
5.  Knowledge of Kaldi: To use the models effectively, it is important to have a basic understanding of how Kaldi works, including how to run scripts, configure models, and decode speech.
By meeting these prerequisites, you can effectively use the models in the repository to build face-domain-specific ASR applications.

# Model information

The basic information about the acoustical model final.mdl is a follows:

- input-dim: 40
- num-pdfs: 3136
- left-context: 16
- right-context: 10
- num-parameters: 6495360

The basic information about the language mode HCLG.fst is a follows:

- fst type: const
- arc type: standard
- number of states: 81604
- number of arcs: 221650

# Model usage
Before using the model the following model files need to be unzipped:

./exp/chain/tdnn/tdnn1a_sp/final.mdl.zip 
./exp/chain/tdnn/tree_1a_sp/graph_obrazi/phones/align_lexicon.int.zip 
./exp/chain/tdnn/tree_1a_sp/graph_obrazi/phones/align_lexicon.txt.zip 
./exp/chain/tdnn/tree_1a_sp/graph_obrazi/words.txt.zip 

The availabel ASR models can then be used for recognizing a Kaldi compatible speech recordings dataset in the data/test_hires folder using the following Kaldi scripts:

steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf --cmd run.pl data/test_hires exp/make_mfcc/test mfcc
steps/compute_cmvn_stats.sh data/test_hires exp/make_mfcc/test mfcc

nspk=$(wc -l <data/test_hires/spk2utt)
steps/nnet3/decode.sh --config conf/decode.config --acwt 1.0 --post-decode-acwt 10.0 
   --extra-left-context 0 --extra-right-context 0 --extra-left-context-initial 0 
   --extra-right-context-final 0 --frames-per-chunk 10 --nj 1 --num-threads 1 
   exp/chain/tdnn/tree_1a_sp/graph_obrazi data/test_hires exp/chain/tdnn/tdnn1a_sp/decode_graph_obrazi_test/
   
The above scripts can also be run using the script:

local/testno_razpoznavanje_interpolirani.sh
./rezultati
