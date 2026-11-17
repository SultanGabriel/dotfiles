# ntfy Bash Notification Wrapper

This script provides one simple `notify` command for sending messages through ntfy.

1. Copy the script to `/usr/local/bin/notify`.
2. Make it executable with `sudo chmod +x /usr/local/bin/notify`.
3. Create `/etc/ntfy-notify.env`.
4. Add `NTFY_URL`, `NTFY_TOPIC`, and optionally `NTFY_TOKEN`.
5. Protect the config with `sudo chmod 600 /etc/ntfy-notify.env`.
6. Send a message with `notify "Title" "Body"`.
7. Optional arguments are priority and tags.
8. Example: `notify "Backup failed" "Postgres backup failed" high warning`.
9. The script can be used from Bash scripts, cron jobs, systemd services, and host automation.
10. All ntfy connection data stays in one central config file.
