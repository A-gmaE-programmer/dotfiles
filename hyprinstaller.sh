#!/bin/bash

workDir=$HOME/HyprlandInstall

yay -Syu
yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus
# Extra deps
yay -S brightnessctl btop cava eog gnome-system-monitor mousepad mpv mpv-mpris nvtop pamixer swayidle vim
# Fonts
yay -S fonts-firecode fonts-font-awesome fonts-noto fonts-noto-cjk fonts-noto-color-emoji
./installJetbrains.sh

git clone https://github.com/jtheoof/swappy.git
cd swappy
meson build
ninja -C build
sudo ninja -C build install
cd $workDir

git clone https://github.com/Horus645/swww.git
cd swww
cargo build --release
./doc/gen.sh
sudo cp target/release/swww /usr/bin/
sudo cp target/release/swww-daemon /usr/bin/
sudo mkdir -p /usr/share/bash-completion/completions
sudo cp completions/swww.bash /usr/share/bash-completion/completions/swww
sudo mkdir -p /usr/share/zsh/site-functions
sudo cp completions/_swww /usr/share/zsh/site-functions/_swww
cd $workDir

yay -S bison flex
git clone https://github.com/lbonn/rofi.git
cd rofi
meson setup build && ninja -C build
sudo ninja -C build install
cd $workDir

yay -S imagemagick python-pywal python

git clone https://github.com/hyprwm/hyprlang.git
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install ./build
cd $workDir

git clone https://github.com/hyprwm/hyprcursor.git
cd hyprcursor
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf NPROCESSORS_CONF`
sudo cmake --install build
cd $workDir

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all && sudo make install
cd $workDir

yay -S unzip gtk2-engines-murrine
git clone https://github.com/JaKooLit/GTK-themes-icons.git
cd GTK-themes-icons
chmod +x auto-extract.sh
./auto-extract.sh
cd $workDir

yay -S bluez blueman
sudo systemctl enable --now bluetooth.service

yay -S ffmpegthumbnailer file-roller thunar thunar-volman tumbler thunar-archive-plugin xarchiver

yay -S sddm qml-module-qtgraphicaleffects qml-module-qtquick-controls qml-module-qtquick-controls2 qml-module-qtquick-extras qml-module-qtquick-layouts
sudo systemctl enable sddm
