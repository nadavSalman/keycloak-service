#!/bin/bash

terraform output  -raw tls_private_key > private.key
chmod 600 private.key 