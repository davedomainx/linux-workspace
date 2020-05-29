#!/bin/bash
python3 -c "import crypt;print(crypt.crypt(input('password: '), crypt.mksalt(crypt.METHOD_SHA512)))"
