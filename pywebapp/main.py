from flask import Flask
from flask import request
import pandas

app = Flask(__name__)

@app.route("/")

def index():
    word = request.args.get("word", "")
    if word:
        count = count_from(word)
    else:
        count = ""
    return (
        """<form action="" method="get">
                Input a word: <input type="text" name="word">
                <input type="submit" value="Count the recurrencies with more than 2 characters">
            </form>"""
        + "count: "
        + count
    )

def count_from(word):
    """Count the recurrenceis."""
    try:
        count=(pandas.Series(list(word)).value_counts())
        count=(count[count > 1].count())
        return str(count)
    except ValueError:
        return "invalid input"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=False)
