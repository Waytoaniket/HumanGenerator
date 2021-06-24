from keras.models import load_model
from keras.preprocessing.image import img_to_array, save_img
from flask import Flask, jsonify, request
from flask_restful import Resource, Api, reqparse
from  PIL import Image

import numpy as np
import io
import time
import base64
import tensorflow as tf


app = Flask(__name__)
api = Api(app)

model = load_model('HumanGeneratorModel.h5')
print('* model loaded')


def prepare_image(image, target):
    if image.mode != 'RGB':
        image = image.convert('RGB')
    image = image.resize(target)
    image = img_to_array(image)
    image = (image - 127.5) / 127.5
    image = np.expand_dims(image, axis=0)

    return image


class Predict(Resource):
    def post(self):
        json_data = request.get_json()
        img_data = json_data['Image']

        image = base64.b64decode(str(img_data))

        img = Image.open(io.BytesIO(image))

        prepared_image = prepare_image(img,(256, 256))

        preds = model.predict(prepared_image)

        outputFile = 'output.png'
        savePath = './Output/'

        output = tf.reshape(preds, [256,256,3])

        output = (output + 1) /2

        save_img(savePath+outputFile, img_to_array(output))
        save_img(savePath+'1'+outputFile, img_to_array(img))


        imageNew = Image.open(savePath+outputFile)
        imageNew = imageNew.resize((50,50))
        imageNew.save(savePath + 'New_'+ outputFile)

        with open(savePath + outputFile, 'rb') as image_file:
            encoded_string = base64.b64encode(image_file.read())

        outputData = {
            'Image' : str(encoded_string)
        }

        return outputData

api.add_resource(Predict, '/predict')

if __name__ == '__main__':
    app.run(debug=True)
