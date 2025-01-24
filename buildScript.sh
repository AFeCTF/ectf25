#!/bin/bash

. ./.venv/bin/activate
rm secrets/secrets.json
rm subscription.bin
python3 -m ectf25_design.gen_secrets secrets/secrets.json 1 3 4
cd ./decoder 
docker build -t decoder .
docker run --rm -v ./build_out:/out -v ./:/decoder -v ./../secrets:/secrets -e DECODER_ID=0xdeadbeef decoder
cd ..
python -m ectf25_design.gen_subscription secrets/secrets.json subscription.bin 0xDEADBEEF 32 128 1
cd ./decoder
python -m ectf25.utils.flash ./build_out/max78000.bin /dev/tty.usbmodem1102
