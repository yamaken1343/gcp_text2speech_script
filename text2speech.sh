#!/usr/bin/env bash
# $ export GOOGLE_APPLICATION_CREDENTIALS=gcp_key.json
# $ bash text2speech.sh "text" "sound.wav/mp3"

echo "{
  \"audioConfig\": {
    \"audioEncoding\": \"LINEAR16\",
    \"pitch\": 1.0,
    \"speakingRate\": 1.0
  },
  \"input\": {
    \"text\": \"$1\"
  },
  \"voice\": {
    \"languageCode\": \"ja-JP\",
    \"name\": \"ja-JP-Wavenet-A\"
  }
}" > tmp_context.json
curl -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) -H "Content-Type: application/json; charset=utf-8" -d @tmp_context.json https://texttospeech.googleapis.com/v1beta1/text:synthesize > tmp_res.txt
sed 's/audioContent/ /' tmp_res.txt | tr -d '\n ":{}' > tmp_audiotxt.txt
base64 tmp_audiotxt.txt --decode > $2
rm tmp*
