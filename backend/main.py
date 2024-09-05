# https://www.w3schools.com/html/mov_bbb.mp4
from flask import Flask, jsonify

app = Flask(__name__)

dummy_data = [
    {"name": "John Doe", "video": "https://www.w3schools.com/html/mov_bbb.mp4"},
    {"name": "Jane Smith", "video": "https://www.w3schools.com/html/mov_bbb.mp4"},
    {"name": "Michael Brown", "video": "https://www.w3schools.com/html/mov_bbb.mp4"},
    {"name": "Emily White", "video": "https://www.w3schools.com/html/mov_bbb.mp4"},
    {"name": "Chris Green", "video": "https://www.w3schools.com/html/mov_bbb.mp4"}
]

@app.route('/api/notifications', methods=['GET'])
def get_notifications():
    return jsonify(dummy_data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
