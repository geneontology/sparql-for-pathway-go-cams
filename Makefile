# Makefile

BLAZEGRAPH_RUNNER_URL := https://github.com/balhoff/blazegraph-runner/releases/download/v1.7/blazegraph-runner-1.7.tgz
BLAZEGRAPH_RUNNER_TGZ := blazegraph-runner-1.7.tgz
BLAZEGRAPH_RUNNER_DIR := blazegraph-runner-1.7
BG_JNL := blazegraph-production.jnl
JAVA_OPTS := -Xmx12G

%/$(BLAZEGRAPH_RUNNER_TGZ):
	mkdir -p $*	
	@echo "Downloading blazegraph-runner..."
	curl -L $(BLAZEGRAPH_RUNNER_URL) -o $@

.PRECIOUS: %/$(BLAZEGRAPH_RUNNER_DIR)/bin/blazegraph-runner
%/$(BLAZEGRAPH_RUNNER_DIR)/bin/blazegraph-runner: %/$(BLAZEGRAPH_RUNNER_TGZ)
	@echo "Decompressing blazegraph-runner..."
	cd $* && tar -xzf $(BLAZEGRAPH_RUNNER_TGZ)

%/run_query: %/$(BLAZEGRAPH_RUNNER_DIR)/bin/blazegraph-runner
	JAVA_OPTS=$(JAVA_OPTS) ./$< select --journal=$(BG_JNL) --outformat=tsv $(QUERY_FILE) $(OUT_FILE)

%/pthwy_gocams_count_mf_roots.tsv:
	QUERY_FILE=sparql/pthwy_gocams_count_mf_roots.rq OUT_FILE=$@ $(MAKE) $*/run_query

%/metabolic_pthwy_gocams_count_mf_roots.tsv:
	QUERY_FILE=sparql/metabolic_pthwy_gocams_count_mf_roots.rq OUT_FILE=$@ $(MAKE) $*/run_query

%/multi_connected_cc_gocams.tsv:
	QUERY_FILE=sparql/multi_connected_cc_gocams.rq OUT_FILE=$@ $(MAKE) $*/run_query

%/multi_connected_bp_gocams.tsv:
	QUERY_FILE=sparql/multi_connected_bp_gocams.rq OUT_FILE=$@ $(MAKE) $*/run_query

%/non_mf_causal_gocams.tsv:
	QUERY_FILE=sparql/non_mf_causal_gocams.rq OUT_FILE=$@ $(MAKE) $*/run_query

.PRECIOUS: %/pathway_like_go_cams.tsv
%/pathway_like_go_cams.tsv: %/pthwy_gocams_count_mf_roots.tsv %/metabolic_pthwy_gocams_count_mf_roots.tsv %/multi_connected_cc_gocams.tsv %/multi_connected_bp_gocams.tsv %/non_mf_causal_gocams.tsv
	./scripts/compile_pathway_like_gocams.sh $*

# NOCTUA_MODELS_PATH is the repo root
%/cp_model_ttl_to_new_dir.touch: %/pathway_like_go_cams.tsv
	mkdir -p $*/pathway_like_go_cams
	./scripts/cp_model_ttl_to_new_dir.sh $< $(NOCTUA_MODELS_PATH) $*/pathway_like_go_cams
	touch $@

.PRECIOUS: %/pathway-like_go-cams.tar.gz
%/pathway-like_go-cams.tar.gz: %/cp_model_ttl_to_new_dir.touch
	tar -czf $@ $*/pathway_like_go_cams

%/all: %/pathway_like_go_cams.tsv %/pathway-like_go-cams.tar.gz
	@echo "Done"