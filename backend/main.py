from flask import Flask, jsonify
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)

dummy_data = [
    {
        "sender": "John Doe",
        "text": "This is a dummy message from John. It contains multiple lines of text for testing.",
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
    },
    {
        "sender": "Jane Smith",
        "text": "Hello from Jane! This is another test message to display in the app.",
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
    },
    {
        "sender": "Michael Brown",
        "text": "Michael says hi! This is yet another sample notification message.",
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
    },
    {
        "sender": "Emily White",
        "text": "This is a message from Emily. It is longer to check the scrollable popup functionality.",
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
    },
    {
        "sender": "Chris Green",
        "text": "Chris is sending a message. Testing scrollable popup with long text.",
        "time": datetime.now().strftime("%Y-%m-%d %H:%M"),
    },
]

@app.route('/api/notifications', methods=['GET'])
def get_notifications():
    return jsonify(dummy_data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
