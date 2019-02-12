#!/bin/sh
mogrify -path thumb -thumbnail 300x300 -format jpg -quality 70 'full/*.{png,jpg}'
