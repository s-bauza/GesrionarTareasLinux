#!/bin/bash
echo -e "Log of cp -r $1 $2 \n$(date)\n\n$(cp -r $1 $2 >> $3 && echo "OK" || echo "FAILED")\n\n$(date)\n\n----------------" >> $3;


