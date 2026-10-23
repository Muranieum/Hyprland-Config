# 1. Set temporary rules using the new windowrule syntax
hyprctl keyword windowrule "match:class ^(discord)$, workspace 11 silent, no_initial_focus yes"
hyprctl keyword windowrule "match:class ^(steam)$, workspace 10 silent, no_initial_focus yes"

# 2. Launch the applications
# Use flags to ensure they start "backgrounded" where possible
discord &
steam &

# 3. Wait for windows to be created
# Forking apps take time to spawn their main window
for i in {1..40}; do
  CLIENTS=$(hyprctl clients)

  # Check Discord (waits for main window, not just 'Discord Updater')
  DISCORD_READY=$(echo "$CLIENTS" | grep -q "title: Discord" && echo "yes")

  # Check Steam (Matches 'Steam', ignores login)
  STEAM_READY=$(echo "$CLIENTS" | grep -E "title: Steam" && echo "yes")

  if [[ "$DISCORD_READY" == "yes" && "$STEAM_READY" == "yes" ]]; then
    # Small extra buffer to ensure Hyprland finishes the window placement
    sleep 1
    break
  fi
  sleep 0.5
done

# 4. Remove the rules so future launches are normal
# If 'unset' fails, reloading the config is the most reliable way to clear temp rules
hyprctl reload
