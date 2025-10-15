Sharing `FINAL VERSION 2.0.html` for playing on other laptops

Local LAN sharing (recommended for quick testing):
1. Ensure Python is installed and on PATH.
2. Open PowerShell in the project folder and run:

   .\serve_game.ps1

   Optionally choose a port:

   .\serve_game.ps1 -Port 8080

3. The script prints URLs like http://192.168.1.42:8000/FINAL%20VERSION%202.0.html — give that to other players on the same Wi‑Fi/LAN.

Sharing over the internet (public):
- Use ngrok (https://ngrok.com). After installing, run the local server then in another shell:

  ngrok http 8000

- ngrok will print a public URL you can share. Note: exposing your local machine has security and privacy implications.

Troubleshooting:
- If assets are missing, run .\rename_assets.ps1 first to move files into `Assets/` and ensure the HTML references are updated.
- If other devices can't connect, check firewall settings to allow inbound connections on the chosen port.
- If Python isn't installed, download from https://python.org and ensure you can run `python -V` from PowerShell.
