#!/bin/bash

kubectl run netshoot --rm -it --restart=Never \
  --image=nicolaka/netshoot \
  -- bash
