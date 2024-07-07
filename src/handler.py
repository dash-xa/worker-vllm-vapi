import os
import runpod
from utils import JobInput
from engine import vLLMEngine, OpenAIvLLMEngine

vllm_engine = vLLMEngine()
OpenAIvLLMEngine = OpenAIvLLMEngine(vllm_engine)

async def handler(job):
    print("job['input'] before:", job["input"])
    
    if "input" in job and "openai_input" in job["input"]:
        openai_input = job["input"]["openai_input"]
        openai_input.pop("call", None)
        openai_input.pop("metadata", None)
        openai_input["stop_token_ids"] = [13]
        
    print("job['input'] after:", job["input"])
    
    job_input = JobInput(job["input"])
    engine = OpenAIvLLMEngine if job_input.openai_route else vllm_engine

    results_generator = engine.generate(job_input)
    async for batch in results_generator:
        yield batch

runpod.serverless.start(
    {
        "handler": handler,
        "concurrency_modifier": lambda x: vllm_engine.max_concurrency,
        "return_aggregate_stream": True,
    }
)