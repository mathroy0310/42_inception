# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    generate_password.sh                               :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: maroy <maroy@student.42quebec.com>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/15 15:49:22 by maroy             #+#    #+#              #
#    Updated: 2024/08/15 15:49:23 by maroy            ###   ########.qc        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# Directory to store secrets
SECRETS_DIR="./secrets"
# Array of file names for passwords
PASSWORD_FILES=("db_password.txt" \
                "db_root_password.txt" \
                "wp_root_password.txt" \
                "wp_password.txt")

# Function to generate a random password
generate_random_password() {
    LC_ALL=C tr -dc "[:alnum:]" </dev/urandom | head -c 12;
}

# Check if secrets directory exists, if not, create it
if [ ! -d "$SECRETS_DIR" ]; then
    mkdir -p "$SECRETS_DIR"
fi

# Loop through the array of password files
for file in "${PASSWORD_FILES[@]}"; do
    file_path="$SECRETS_DIR/$file"
    # Check if file exists, if not, create it and fill it with a random password
    if [ ! -f "$file_path" ]; then
        PASSWORD=$(generate_random_password)
        echo "$PASSWORD" > "$file_path"
        echo "Generated new $file: $PASSWORD"
    fi
done