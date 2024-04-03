using BenchmarkTools

RES_DIR = "./benchmark/results"
OLD_RESULTS = "benchres_benchmarking-8e44d82c_2024-04-03_15-03-48.json"

# Load latest result
NEW_RESULTS =  sort(readdir(RES_DIR), by=x->last(x,24)) |> last

old_results = BenchmarkTools.load(joinpath(RES_DIR, OLD_RESULTS))[1]
new_results = BenchmarkTools.load(joinpath(RES_DIR, NEW_RESULTS))[1]

BenchmarkTools.judge(median(old_results), median(new_results))