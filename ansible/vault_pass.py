#!/usr/bin/env python3
import os
import sys
import subprocess
from dotenv import load_dotenv

load_dotenv()


if __name__ == '__main__':
    password = os.environ.get('VAULT_PASSWORD')
    pass_path = os.environ.get('VAULT_PASS_PATH')

    if password:
        sys.stdout.write(password.strip())
    elif pass_path:
        try:
            result = subprocess.run(['pass', pass_path], capture_output=True, text=True, check=True)
            sys.stdout.write(result.stdout.strip())
        except subprocess.CalledProcessError as e:
            sys.stdout.write(e)
            exit(1)
