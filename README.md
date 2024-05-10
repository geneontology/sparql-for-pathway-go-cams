# sparql-for-pathway-go-cams
SPARQL queries and pipeline for filtering "pathway-like" GO-CAM models and packaging into tarball

## Running
1. Download and extract [blazegraph-production.jnl](http://current.geneontology.org/products/blazegraph/blazegraph-production.jnl.gz).
2. Git clone [noctua-models](https://github.com/geneontology/noctua-models) and supply path to `noctua-models` directory in `NOCTUA_MODELS_PATH` when running `make`.
```
NOCTUA_MODELS_PATH={path-to-noctua-models} make target/pathway-like_go-cams.tar.gz
```
This will execute the following steps:
1. Download [blazegraph-runner](https://github.com/balhoff/blazegraph-runner) software
2. Run SPARQL queries
3. Compile results into a TSV (`pathway_like_go_cams.tsv`)
4. Copy `.ttl` model files from `noctua-models/models/` and package them into `pathway-like_go-cams.tar.gz`