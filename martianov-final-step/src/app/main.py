from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def get_host_ip():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    return f"""
    <html>
    <head>
        <style>
            body {{
                background-color: #cce5ff; /* светло-синий */
                font-size: 24px;
                font-family: Arial, sans-serif;
                padding: 20px;
            }}
            strong {{
                color: #004085; /* тёмно-синий */
            }}
        </style>
    </head>
    <body>
        <strong>Host IP:</strong> {ip}
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
