#!/bin/bash

# Créer le dossier assets/models s'il n'existe pas
mkdir -p assets/models

# Télécharger le modèle SSD MobileNetV2
curl -L "https://tfhub.dev/tensorflow/lite-model/ssd_mobilenet_v2/1/metadata/2?lite-format=tflite" -o assets/models/ssd_mobilenet_v2.tflite

# Télécharger le fichier de labels
curl -L "https://raw.githubusercontent.com/tensorflow/models/master/research/object_detection/data/mscoco_label_map.pbtxt" -o assets/models/labels.txt

echo "Modèle et labels téléchargés avec succès !" 