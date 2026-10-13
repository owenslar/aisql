"""Ask natural-language questions about the high school golf database.

Usage:
    python aisql.py "Who won the most tournaments?"   # one question, appends to log files
    python aisql.py                                    # built-in questions, overwrites log files
"""

import json
import os
import sqlite3
import sys

from openai import OpenAI

MODEL = "gpt-4o-mini"
DB_PATH = "aisql.db"
SCHEMA_FILE = "setup.sql"
DATA_FILE = "setupData.sql"

BATCH_QUESTIONS = [
    "Who has the lowest average 18 hole score?",
    "What team has the lowest average score across all tournaments?",
    "Which course is the hardest by slope rating?",
    "Which player won the most tournaments?",
    "Which team had the best combined score at each tournament?",
    "Which players withdrew before finishing a round?",
    "Which seniors in the class of 2025 played in every tournament?",
    "Which players have played for more than one team?",
    "What is the average 18 hole score for each division?",
    "Which players have never played in a tournament?",
]


def load_file(path):
    with open(path) as f:
        return f.read()


def setup_database():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON")
    conn.executescript(load_file(SCHEMA_FILE))
    conn.executescript(load_file(DATA_FILE))
    conn.commit()
    return conn


setupSqlScript = load_file(SCHEMA_FILE)
commonSqlOnlyRequest = " Give me a sqlite select statement that answers the question. Only respond with sqlite syntax. If there is an error do not explain it!"
strategies = {
    "zero_shot": setupSqlScript + commonSqlOnlyRequest,
    "single_domain_double_shot": (setupSqlScript +
                   " Which player had the lowest total score at the Timpanogos Invitational? " +
                   " \nSELECT p.first_name, p.last_name, pt.front_nine_score + pt.back_nine_score AS total_score\nFROM player p\nJOIN player_tournament pt ON p.player_id = pt.player_id\nJOIN tournament t ON pt.tournament_id = t.tournament_id\nWHERE t.name = 'Timpanogos Invitational' AND pt.back_nine_score IS NOT NULL\nORDER BY total_score ASC\nLIMIT 1;\n " +
                   commonSqlOnlyRequest),
}


def get_chat_response(client, content):
    response = client.chat.completions.create(
        model=MODEL,
        messages=[{"role": "user", "content": content}],
    )
    return response.choices[0].message.content


def sanitize_sql(text):
    # models sometimes wrap the query in a markdown code block despite instructions
    if "```" in text:
        text = text.split("```")[1]
        if text.lower().startswith("sql"):
            text = text[3:]
    return text


def ask_question(client, conn, prompt_prefix, question):
    result = {
        "question": question,
        "sql": "",
        "queryRawResponse": "",
        "friendlyResponse": "",
        "error": "None",
    }
    try:
        sql = sanitize_sql(get_chat_response(client, prompt_prefix + " " + question))
        result["sql"] = sql
        rows = conn.execute(sql).fetchall()
        result["queryRawResponse"] = str(rows)
        friendly_prompt = (
            f'I asked a question "{question}" and the response was "{rows}". '
            "Please give a concise, friendly answer in one short sentence. "
            "Do not mention SQL, queries, or databases, and do not give any other explanation."
        )
        result["friendlyResponse"] = get_chat_response(client, friendly_prompt)
    except Exception as e:
        result["error"] = str(e)
    return result


def log_path(strategy):
    return f"response_{strategy}.json"


def load_log(strategy, append):
    path = log_path(strategy)
    if append and os.path.exists(path):
        with open(path) as f:
            return json.load(f)
    return {"strategy": strategy, "prompt_prefix": strategies[strategy], "questionResults": []}


def save_log(strategy, log):
    with open(log_path(strategy), "w") as f:
        json.dump(log, f, indent=2)


def main():
    with open("config.json") as f:
        config = json.load(f)
    client = OpenAI(api_key=config["openaiKey"])
    conn = setup_database()

    single_question = len(sys.argv) > 1
    questions = [" ".join(sys.argv[1:])] if single_question else BATCH_QUESTIONS

    for strategy, prompt_prefix in strategies.items():
        log = load_log(strategy, append=single_question)
        print(f"\n=== {strategy} ===")
        for question in questions:
            result = ask_question(client, conn, prompt_prefix, question)
            log["questionResults"].append(result)
            print(f"\nQ: {question}")
            print(f"A: {result['friendlyResponse'] or 'Error: ' + result['error']}")
        save_log(strategy, log)

    conn.close()


if __name__ == "__main__":
    main()
