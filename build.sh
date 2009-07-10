#!/bin/bash
gcc -Wall -g -I ~/parrot/include/1.3.0-devel/ -shared -fPIC `pkg-config evas --cflags --libs` evas_cb_helper.c -o evas_cb_helper.so
