#!/bin/bash

date=$(date +%Y-%m-%d\ %H:%M)

git add .
git commit -m "Update $date"
git push origin main
