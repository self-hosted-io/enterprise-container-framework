# Local Dev

Create a cloudflared tunnel to your local machine with docker

docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token <token>

configure the service endpoint to your host machine ie `http://localhost:8000`

# run the dev server
`fastapi run --host 0.0.0.0 --port 8000 main.py`