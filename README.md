# VPS/Dedicated Stats Checker

## Table of Contents
- [Overview](README.md#Overview)
- [Why](README.md#Why)
- [Screenshots](README.md#Screenshots)
- [Features](README.md#Features)
  - [Show CPU Usage](README.md#Show-CPU-Usage)
  - [Show Disk Usage](README.md#Show-Disk-Usage)
  - [Show Hardware](README.md#Show-Hardware)
  - [Show Network Usage](README.md#Show-Network-Usage)
  - [Show RAM Usage](README.md#Show-RAM-Usage)
  - [Show Time and Date](README.md#Show-Time-and-Date)
- [Installation](README.md#Installation)
  - [Debian or other Linux Distros](README.md#Debian-or-other-Linux-Distros)
- [Troubleshooting](README.md#ITroubleshooting)
- [Bug Reports](README.md#Bug-Reports)
- [License](README.md#License)

## Overview

This script shows your statistics on your Discord server, to a specific channel using a webhook. Make a Pull Request if you want anything else added!

## Why?

Boredom. Just trying to get my server stats to show on my Discord.

## Screenshots
![image](https://github.com/user-attachments/assets/f369709b-53ef-4cb5-87e2-2e7c204a113c)

## Features

### Show CPU Usage

- Sync Profiles with Steam & Discord: Users and staff can easily log in and link their profiles using Steam and/or Discord. You have full control over which linked social profiles appear on your page.
- API Integration: Display relevant social data via API calls to Steam and Discord.

### Show Disk Usage

- Track player performance with HLStatsX compatible tracking
- Allow users to show their stats on their profile along side their Steam and Discord informaiton
- Allow users to embed a HTML display of their stats link anywhere embedding is allowed, such as forum signatures!

### Show Hardware

- Multi-Game Ban Support: Easily manage bans and unbans across a variety of popular gaming platforms, including:
  - Source Engine Games/Mods (e.g., Counter-Strike, TF2)
  - GoldSrc Engine Games/Mods (e.g., Half-Life, Day of Defeat)
  - Minecraft server integration for various platforms (Spigot, CraftBukkit, Forge)
  - Make your own support! Your game isn't supported? Use the API to code your own plugin to interface with the website
  - Advanced Ban Features: Import SourceBans, AMXBansX, and more!

### Show Network Usage

- Track User Engagement: Staff can access detailed analytics about user activities on the site, such as:
  - Visitor statistics
  - Ban and donation data
  - Audit logs for transparency
  - Google Analytics and Google Tag Manager are supported, just follow the instructions!
  - Only users with the correct permissions can set/see Analytics API information
  - Track how users view your site
  - And more…

### Show RAM Usage

- Support for Donations: Easily manage donation packages and payment processing.
  - Stripe: Process payments with debit/credit cards via Stripe (Card Brands Supported)
  - PayPal: Users can donate through PayPal with a quick login process.
  - Subscription or One-Time Payments: Offer recurring packages with clear labeling for both subscriptions and one-time payments.

### Show Time and Date

- Reward User Activity: Enable a toggleable gamification system to incentivize user participation.
- Level Up: Sync users’ level progression with Discord and/or game servers.
- Custom Rewards: Create personalized rewards for active users, such as badges, experience bonuses, and stickers.

## Installation

### Debian or other Linux Distros
1. Install bc and curl with whatever package manager you use, for example: `sudo apt update && sudo apt install curl bc -y`
2. Put the server_status.sh file somewhere.
3. Allow the file to be executed `chmod +x server_status.sh`
4. Manually execute it by running `./server_status.sh` or `sh server_status.sh`
5. (Optional) You can also crontab to make this run automatically!
  - (Optional) Run `crontab -e`
  - Add `*/5 * * * * /bin/bash /path/to/server_status.sh`
    - You can also change the time, if you know how to use Crontab. (Use `man crontab` for documentation)

## Troubleshooting

- Coming Soon: A detailed installation guide will be available in the wiki and [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Bug Reports

- See [SECURITY.md](SECURITY.md) for vulnerability reporting. All other reports of minor bugs can be reported normally.

## License

All files on this Github are licensed as described in [LICENSE.md](LICENSE.md).
