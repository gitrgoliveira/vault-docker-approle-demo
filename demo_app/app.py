import os
import logging
import random
import string
import json
import requests

from flask import Flask, session
from flask.logging import default_handler
from flask_session import Session


def counter():

    storage_path = '/app/secret'
    data = ""
    try:
        with open(storage_path) as fp:
            for line in fp:
                data = data + "%s</br>" % (line)
    except:
        data = "exception"

    output = "</br>\
            </br>\
            This is a simple dashboard, rendered server-side</br>\
            </br>\
            </br>\
            Values in path \"{storage_path}\"</br>\
            <pre>{data}</pre></br>\
            </br>\
            </br>\
            ".format(data=data,
                     storage_path=storage_path)

    return output

def create_app():
    app = Flask(__name__)
    app.secret_key = ''.join(random.choice(string.ascii_lowercase) for i in range(256))
    app.config['SESSION_TYPE'] = 'filesystem'
    sess = Session()
    sess.init_app(app)

    @app.route('/')
    def default():
        return counter()

    return app

if __name__ == '__main__':
    create_app().run(host='0.0.0.0')
