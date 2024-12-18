from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

EXCHANGE_RATES = {
    "USD": {"RUB": 100, "EUR": 0.95, "USD": 1},
    "EUR": {"RUB": 105, "USD": 1.05, "EUR": 1},
    "RUB": {"USD": 0.01, "EUR": 0.009, "RUB": 1},
}

@app.route('/api/convert', methods=['POST'])
def convert_currency():
    data = request.json
    amount = data.get("amount", 0)
    from_currency = data.get("from", "RUB")
    to_currency = data.get("to", "USD")

    rate = EXCHANGE_RATES.get(from_currency, {}).get(to_currency, 1)
    result = amount * rate

    return jsonify({"result": round(result, 2)})

@app.route('/api/date', methods=['GET'])
def get_date():
    today = datetime.now().strftime("%d-%m-%Y")
    return jsonify({"date": today})

if __name__ == '__main__':
    print("spesi")
    app.run(host="0.0.0.0", port=5000)
