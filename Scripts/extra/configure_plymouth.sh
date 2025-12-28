#!/usr/bin/env bash
#|---/ /+------------------------------------------+---/ /|#
#|--/ /-| Script to configure Plymouth boot splash|--/ /-|#
#|-/ /--| TonylandDE                               |-/ /--|#
#|/ /---+------------------------------------------+/ /---|#

scrDir=$(dirname "$(realpath "$0")")
source "${scrDir}/../global_fn.sh"

print_log -g "[PLYMOUTH] " -b "Configuring :: " "Plymouth Boot Splash"

# Check if plymouth is installed
if ! pkg_installed plymouth; then
    print_log -r "[PLYMOUTH] " -err "not installed" "Install plymouth first: yay -S plymouth plymouth-theme-hud-git"
    exit 1
fi

# Set HUD theme as default
if plymouth-set-default-theme -l | grep -q "hud"; then
    print_log -g "[PLYMOUTH] " -b "Setting theme :: " "HUD"
    sudo plymouth-set-default-theme -R hud
    print_log -g "[PLYMOUTH] " -stat "applied" "HUD theme"
else
    print_log -y "[PLYMOUTH] " -wrn "theme not found" "HUD theme not installed. Install: yay -S plymouth-theme-hud-git"
    # List available themes
    print_log -g "[PLYMOUTH] " -b "Available themes:"
    plymouth-set-default-theme -l
    exit 1
fi

# Add plymouth hook to mkinitcpio if not present
print_log -g "[PLYMOUTH] " -b "Configuring :: " "mkinitcpio.conf"

# Backup original config
sudo cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup

# Add plymouth before encrypt if not already present
if ! sudo grep "^HOOKS" /etc/mkinitcpio.conf | grep -q "plymouth"; then
    # Check if encrypt or sd-encrypt hook exists (LUKS)
    if sudo grep "^HOOKS" /etc/mkinitcpio.conf | grep -qE "encrypt|sd-encrypt"; then
        print_log -g "[PLYMOUTH] " -b "LUKS detected :: " "Configuring for encrypted disk"
        
        # For systemd-based hooks (sd-encrypt)
        if sudo grep "^HOOKS" /etc/mkinitcpio.conf | grep -q "sd-encrypt"; then
            sudo sed -i '/^HOOKS=/s/\(base systemd [^)]*\)sd-encrypt/\1plymouth sd-encrypt/' /etc/mkinitcpio.conf
        # For traditional encrypt hook
        else
            sudo sed -i '/^HOOKS=/s/\(base udev [^)]*\)encrypt/\1plymouth encrypt/' /etc/mkinitcpio.conf
        fi
    else
        # No encryption, add plymouth after base udev
        sudo sed -i '/^HOOKS=/s/\(base udev [^)]*\)autodetect/\1plymouth autodetect/' /etc/mkinitcpio.conf
    fi
    print_log -g "[PLYMOUTH] " -stat "updated" "mkinitcpio.conf"
else
    print_log -g "[PLYMOUTH] " -stat "already configured" "mkinitcpio.conf (plymouth hook present)"
fi

# Regenerate initramfs
print_log -g "[PLYMOUTH] " -b "Regenerating :: " "initramfs"
sudo mkinitcpio -P
print_log -g "[PLYMOUTH] " -stat "regenerated" "initramfs"

# Configure GRUB
if [ -f /etc/default/grub ]; then
    print_log -g "[PLYMOUTH] " -b "Configuring :: " "GRUB"
    
    # Backup GRUB config
    sudo cp /etc/default/grub /etc/default/grub.backup
    
    # Add quiet splash to GRUB_CMDLINE_LINUX_DEFAULT if not present
    if ! grep -q "quiet splash" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 quiet splash"/' /etc/default/grub
        print_log -g "[PLYMOUTH] " -stat "updated" "GRUB config"
    else
        print_log -g "[PLYMOUTH] " -stat "already configured" "GRUB config"
    fi
    
    # Regenerate GRUB config
    print_log -g "[PLYMOUTH] " -b "Regenerating :: " "GRUB config"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    print_log -g "[PLYMOUTH] " -stat "regenerated" "GRUB config"
fi

# Configure systemd-boot if present
if [ -d /boot/loader/entries ]; then
    print_log -g "[PLYMOUTH] " -b "Configuring :: " "systemd-boot"
    for entry in /boot/loader/entries/*.conf; do
        if ! grep -q "quiet splash" "$entry"; then
            sudo sed -i 's/options \(.*\)/options \1 quiet splash/' "$entry"
        fi
    done
    print_log -g "[PLYMOUTH] " -stat "configured" "systemd-boot entries"
fi

print_log -g "[PLYMOUTH] " -stat "completed" "Plymouth configuration"
print_log -y "[PLYMOUTH] " -b "Note: " "Reboot to see Plymouth boot splash"
