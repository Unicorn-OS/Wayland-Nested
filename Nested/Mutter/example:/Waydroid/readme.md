source: https://www.reddit.com/r/EndeavourOS/comments/11kxlyu/is_there_an_idiotproof_guide_for_running_waydroid/

```mutter --nested --wayland waydroid show-full-ui```

sch: https://www.google.com/search?q=mutter+nested+wayland

# with: Gnome Terminal
- [How to open gnome-terminal in a nested mutter(wayland) window](https://askubuntu.com/questions/1288624/how-to-open-gnome-terminal-in-a-nested-mutterwayland-window)

```
export $(dbus-launch)
mutter --nested --wayland
WAYLAND_DISPLAY=wayland-0 gnome-terminal
```
