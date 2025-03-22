#!/usr/bin/env bash
set -e

# If running as root, optionally adjust UID/GID
if [ "$(id -u)" -eq 0 ]; then
    TARGET_UID="${UID:-1001}"
    TARGET_GID="${GID:-1001}"

    CURRENT_UID="$(id -u focalboard)"
    CURRENT_GID="$(id -g focalboard)"

    # Only change GID if needed and if target GID is not already taken
    if [ "$TARGET_GID" != "$CURRENT_GID" ]; then
        if ! getent group "$TARGET_GID" > /dev/null; then
            groupmod -g "$TARGET_GID" focalboard
        fi
    fi

    # Only change UID if needed and if target UID is not already taken
    if [ "$TARGET_UID" != "$CURRENT_UID" ]; then
        if ! getent passwd "$TARGET_UID" > /dev/null; then
            usermod -u "$TARGET_UID" -g "$TARGET_GID" focalboard
        fi
    fi

    # Ensure required directories exist with proper ownership
    mkdir -p /opt/focalboard/data /opt/focalboard/files
    chown -R focalboard:focalboard /opt/focalboard

    exec gosu focalboard "$@"
else
    # Non-root: just make sure directories exist (permission errors may occur if volumes are not owned)
    mkdir -p /opt/focalboard/data /opt/focalboard/files
    exec "$@"
fi
