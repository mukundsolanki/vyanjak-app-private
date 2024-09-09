from flask import Flask, jsonify
import requests
import threading

app = Flask(__name__)

# Replace this with the actual IP address of the device running the Flutter app
FLUTTER_SERVER_URL = 'http://192.168.29.77:5500/incoming_call'

def send_request_to_flutter():
    try:
        print("Sending request to Flutter app...")

        # Define the JSON payload
        payload = {
            'name': 'Mukund',
            'ipaddress': '192.168.29.192'  # Replace with the actual server IP address
        }

        # Send the POST request to the Flutter app's server
        response = requests.post(FLUTTER_SERVER_URL, json=payload)
        
        if response.status_code == 200:
            print("Call triggered successfully on Flutter app")
        else:
            print(f"Failed to trigger call on Flutter app: {response.status_code}")
    except Exception as e:
        print(f"Error: {str(e)}")

# Automatically send the request when the server starts
def send_request_on_startup():
    threading.Thread(target=send_request_to_flutter).start()

@app.route('/trigger_call', methods=['GET'])
def trigger_call():
    # Manually trigger the request by accessing this endpoint
    send_request_to_flutter()
    return jsonify({'message': 'Request sent to Flutter app'}), 200

if __name__ == '__main__':
    print("Python server started on port 5000")
    # Send the request immediately on server startup
    send_request_on_startup()
    app.run(host='0.0.0.0', port=5000)
