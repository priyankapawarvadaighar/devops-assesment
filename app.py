import subprocess
from flask import Flask, request, jsonify

# Define the Terraform configuration directory
TERRAFORM_DIR = '/Users/priyankapawar/Desktop/priyanka/kubernetes/assesment'

app = Flask(__name__)

@app.route('/api/v1/provision', methods=['POST'])
def provision_infrastructure():
    try:
        # Run Terraform commands to provision infrastructure
        result = subprocess.run(['terraform', 'apply', '-auto-approve'], capture_output=True, text=True)
        return jsonify({'output': result.stdout})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/destroy', methods=['POST'])
def destroy_infrastructure():
    try:
        result = subprocess.run(['terraform', 'destroy', '-auto-approve'], capture_output=True, text=True)
        return jsonify({'output': result.stdout})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/update', methods=['POST'])
def update_infrastructure():
    try:
        result = subprocess.run(['terraform', 'apply', '-auto-approve'], capture_output=True, text=True)
        return jsonify({'output': result.stdout})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/v1/status', methods=['GET'])
def status_infrastructure():
    try:
        result = subprocess.run(['terraform', 'show'], capture_output=True, text=True)
        return jsonify({'output': result.stdout})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000)
