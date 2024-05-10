#!/bin/bash

TARGET_DIR=$1

rm -f $TARGET_DIR/pathway_like_gocams.tsv $TARGET_DIR/pathway_like_gocams_uniq.tsv $TARGET_DIR/pathway_like_gocams_filtered_multi_bp.tsv $TARGET_DIR/pathway_like_gocams_filtered_multi_bp_cc.tsv
touch $TARGET_DIR/pathway_like_gocams.tmp.tsv
cut -f1,2 $TARGET_DIR/pthwy_gocams_count_mf_roots.tsv | sort | uniq >> $TARGET_DIR/pathway_like_gocams.tmp.tsv
cut -f1,2 $TARGET_DIR/metabolic_pthwy_gocams_count_mf_roots.tsv | sort | uniq >> $TARGET_DIR/pathway_like_gocams.tmp.tsv
sort $TARGET_DIR/pathway_like_gocams.tmp.tsv | uniq > $TARGET_DIR/pathway_like_gocams_uniq.tsv
grep model.geneontology.org $TARGET_DIR/multi_connected_bp_gocams.tsv | cut -f1 | grep -v -f /dev/stdin $TARGET_DIR/pathway_like_gocams_uniq.tsv > $TARGET_DIR/pathway_like_gocams_filtered_multi_bp.tsv
grep model.geneontology.org $TARGET_DIR/multi_connected_cc_gocams.tsv | cut -f1 | grep -v -f /dev/stdin $TARGET_DIR/pathway_like_gocams_filtered_multi_bp.tsv > $TARGET_DIR/pathway_like_gocams_filtered_multi_bp_cc.tsv 
grep model.geneontology.org $TARGET_DIR/non_mf_causal_gocams.tsv | cut -f1 | sort | uniq | grep -v -f /dev/stdin $TARGET_DIR/pathway_like_gocams_filtered_multi_bp_cc.tsv | \
sed 's/http:\/\/model\.geneontology\.org\//http:\/\/noctua\.geneontology\.org\/editor\/graph\/gomodel:/g' | sed 's/<//g' | sed 's/>//g' > $TARGET_DIR/pathway_like_go_cams.tsv